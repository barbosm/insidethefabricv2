# Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.22.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  region = var.region
}


# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_public
  availability_zone = var.az
  tags = {
    Name        = var.subnet_public_name
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_private
  availability_zone = var.az
  tags = {
    Name        = var.subnet_public_name
    Environment = var.environment
  }
}

resource "aws_security_group" "public" {
  name        = var.sg_name_public
  description = var.sg_name_public
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.sg_name_public
    Environment = var.environment
  }
}

resource "aws_security_group" "private" {
  name        = var.sg_name_private
  description = var.sg_name_private
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.sg_name_private
    Environment = var.environment
  }
}

resource "aws_network_interface" "public" {
  description = var.interface_name_public
  subnet_id   = aws_subnet.public.id
}

resource "aws_network_interface" "private" {
  description       = var.interface_name_private
  subnet_id         = aws_subnet.private.id
  source_dest_check = false
}

resource "aws_network_interface_sg_attachment" "public" {
  security_group_id    = aws_security_group.public.id
  network_interface_id = aws_network_interface.public.id
}

resource "aws_network_interface_sg_attachment" "private" {
  security_group_id    = aws_security_group.private.id
  network_interface_id = aws_network_interface.private.id
}


# Instance
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

data "template_file" "fgtvm" {
  template = file(var.bootstrap_fgtvm)
}


resource "aws_instance" "fgtvm" {
  ami               = var.ami
  instance_type     = var.size
  availability_zone = var.az
  key_name          = aws_key_pair.this.key_name
  user_data         = data.template_file.fgtvm.rendered

  root_block_device {
    volume_type = "standard"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.public.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.private.id
    device_index         = 1
  }

  tags = {
    Name        = var.vm_name
    Environment = var.environment
  }
}


# Routing
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.rt_name_public
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.rt_name_private
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "private" {
  depends_on             = [aws_instance.fgtvm]
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.private.id

}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "this" {
  vpc               = true
  network_interface = aws_network_interface.public.id
}


# Outputs
output "FG_Public_IP" {
  value = aws_eip.this.public_ip
}

output "Username" {
  value = "admin"
}

output "Password" {
  value = aws_instance.fgtvm.id
}
