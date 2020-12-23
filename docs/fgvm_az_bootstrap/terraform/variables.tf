# Resource Group 
variable "rgname" {
  type    = string
  default = "fgtsingle-mb"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "environment" {
  type        = string
  description = "Environment Tag"
  default     = "Terraform Demo"
}

# Network
variable "vnet" {
  type    = string
  default = "fgtvnetwork"
}

variable "vnetcidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "vnetpublicname" {
  type    = string
  default = "publicSubnet"
}

variable "publiccidr" {
  type    = string
  default = "10.1.0.0/24"
}

variable "vnetprivatename" {
  type    = string
  default = "privateSubnet"
}

variable "privatecidr" {
  type    = string
  default = "10.1.1.0/24"
}

variable "fgpublicipname" {
  type    = string
  default = "FGTPublicIP"
}

variable "public_nsg_name" {
  type    = string
  default = "PublicNetworkSecurityGroup"
}

variable "private_nsg_name" {
  type    = string
  default = "PrivateNetworkSecurityGroup"
}

variable "public_interface_name" {
  type    = string
  default = "fgtport1"
}

variable "private_interface_name" {
  type    = string
  default = "fgtport2"
}

variable "ipconfig_name" {
  type        = string
  description = "IP Configuration Name. Does not have to be unique."
  default     = "ipconfig1"
}

# Instance
variable "vm_name" {
  type    = string
  default = "fgtvm"
}

variable "size" {
  type    = string
  default = "Standard_F4"
}

variable "publisher" {
  type    = string
  default = "fortinet"
}

variable "fgtoffer" {
  type    = string
  default = "fortinet_fortigate-vm_v5"
}

variable "fgtsku" {
  type    = string
  default = "fortinet_fg-vm_payg_20190624"
}

variable "fgtversion" {
  type    = string
  default = "6.4.1"
}

variable "adminusername" {
  type    = string
  default = "azureadmin"
}

variable "adminpassword" {
  type    = string
  default = "Fortinet123#"
}

variable "bootstrap_fgtvm" {
  type    = string
  default = "fgtvm.conf"
}
