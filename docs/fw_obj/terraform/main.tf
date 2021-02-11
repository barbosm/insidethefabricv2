variable "fw_addr" {
  type = map(string)
  default = {
    "name"   = "Finance-Server"
    "subnet" = "10.100.77.200/32"
  }
}

resource "fortios_firewall_address" "fw_addr" {
  name   = var.fw_addr.name
  subnet = var.fw_addr.subnet
}
