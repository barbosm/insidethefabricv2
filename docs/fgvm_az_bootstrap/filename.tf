# Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Resource Group 
resource "azurerm_resource_group" "this" {
  name     = var.rgname
  location = var.location
  tags = {
    environment = var.environment
  }
}


# Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet
  address_space       = [var.vnetcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "public" {
  name                 = var.vnetpublicname
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.publiccidr]
}

resource "azurerm_subnet" "private" {
  name                 = var.vnetprivatename
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.privatecidr]
}

resource "azurerm_public_ip" "this" {
  name                = var.fgpublicipname
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "public" {
  name                = var.public_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "TCP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "private" {
  name                = var.private_nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "All"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "public" {
  name                = var.public_interface_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.this.id
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "private" {
  name                = var.private_interface_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface_security_group_association" "public" {
  network_interface_id      = azurerm_network_interface.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_network_interface_security_group_association" "private" {
  network_interface_id      = azurerm_network_interface.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}


# Storage
resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.this.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "this" {
  # name can only consist of lowercase letters and numbers, and must be
  # between 3 and 24 characters long
  name                     = random_id.randomId.hex
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = var.environment
  }
}


# Instance
resource "azurerm_virtual_machine" "fgtvm" {
  name                         = var.vm_name
  location                     = var.location
  resource_group_name          = azurerm_resource_group.this.name
  vm_size                      = var.size
  primary_network_interface_id = azurerm_network_interface.public.id

  network_interface_ids = [
    azurerm_network_interface.public.id,
    azurerm_network_interface.private.id,
  ]

  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.fgtsku
    version   = var.fgtversion
  }

  plan {
    name      = var.fgtsku
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "osDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgtvm.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.this.primary_blob_endpoint
  }

  tags = {
    environment = var.environment
  }
}

data "template_file" "fgtvm" {
  template = file(var.bootstrap_fgtvm)
}

# Routing
resource "azurerm_route_table" "private" {
  depends_on          = [azurerm_virtual_machine.fgtvm]
  name                = "InternalRouteTable1"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_route" "default" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.this.name
  route_table_name       = azurerm_route_table.private.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.private.private_ip_address
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.private.id
}


# Outputs
output "Resource_Group" {
  value = azurerm_resource_group.this.name
}

output "FG_Public_IP" {
  value = azurerm_public_ip.this.ip_address
}

output "Username" {
  value = var.adminusername
}

output "Password" {
  value = var.adminpassword
}
