# Provider
# Region
variable "region" {
  type    = string
  default = "us-east1"
}

# Zone
variable "zone" {
  type    = string
  default = "us-east1-b"
}

# Project
variable "project" {
  type    = string
  default = "YOUR_PROJECT_ID"
}

# VPC
variable "network_public_name" {
  type    = string
  default = "mb-demo-public"
}

variable "network_private_name" {
  type    = string
  default = "mb-demo-private"
}

variable "subnet_public" {
  default = "10.1.0.0/24"
}

variable "subnet_public_name" {
  type    = string
  default = "public-subnet1"
}

variable "subnet_private" {
  default = "10.1.1.0/24"
}

variable "subnet_private_name" {
  type    = string
  default = "private-subnet1"
}

variable "sg_name_public" {
  type    = string
  default = "public-allow"
}

variable "sg_name_private" {
  type    = string
  default = "allow-all"
}

# Instance
variable "vm_name" {
  type    = string
  default = "fgtvm"
}

variable "image" {
  type = string
  # FG 6.4.1 ON-DEMAND
  default = "projects/fortigcp-project-001/global/images/fortinet-fgtondemand-641-20200610-001-w-license"
}

variable "type" {
  type    = string
  default = "n1-standard-1"
}

variable "bootstrap_fgtvm" {
  type    = string
  default = "fgtvm.conf"
}
