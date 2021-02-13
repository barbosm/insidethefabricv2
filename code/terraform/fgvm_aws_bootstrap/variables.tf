# Provider
variable "region" {
  type    = string
  default = "us-east-1"
}


# VPC
variable "cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "Terraform Demo"
}

variable "environment" {
  type        = string
  description = "Environment Tag"
  default     = "Terraform Demo"
}

variable "az" {
  default = "us-east-1a"
}

variable "subnet_public" {
  default = "10.1.0.0/24"
}

variable "subnet_public_name" {
  type    = string
  default = "public subnet az1"
}

variable "subnet_private" {
  default = "10.1.1.0/24"
}

variable "subnet_private_name" {
  type    = string
  default = "private subnet az1"
}

variable "interface_name_public" {
  type    = string
  default = "fgt_port1"
}

variable "interface_name_private" {
  type    = string
  default = "fgt_port2"
}

variable "sg_name_public" {
  type    = string
  default = "Public Allow"
}

variable "sg_name_private" {
  type    = string
  default = "Allow All"
}


# Instance
variable "key_name" {
  # cat ~/.ssh/id_rsa.pub | cut -f3 -d' '
  default = "me@my-computer"
}

variable "ami" {
  type    = string
  default = "ami-0c184c594e9203c45" # us-east-1
}

variable "size" {
  default = "c5n.xlarge"
}

variable "vm_name" {
  type    = string
  default = "fgtvm"
}

variable "bootstrap_fgtvm" {
  type    = string
  default = "fgtvm.conf"
}


# Routing
variable "igw_name" {
  type    = string
  default = "fgtvm-igw"
}

variable "rt_name_public" {
  type    = string
  default = "fgtvm-public-rt"
}

variable "rt_name_private" {
  type    = string
  default = "fgtvm-private-rt"
}
