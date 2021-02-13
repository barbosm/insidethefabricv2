variable "policy_any" {
  default = {
    id       = 1000
    name     = "any"
    srcintf  = "any"
    dstintf  = "any"
    srcaddr  = "all"
    dstaddr  = "all"
    service  = "ALL"
    action   = "accept"
    schedule = "always"
  }
}

resource "fortios_firewall_policy" "any" {
  policyid = var.policy_any.id
  name     = var.policy_any.name
  srcintf { name = var.policy_any.srcintf }
  dstintf { name = var.policy_any.dstintf }
  srcaddr { name = var.policy_any.srcaddr }
  dstaddr { name = var.policy_any.dstaddr }
  service { name = var.policy_any.service }
  action   = var.policy_any.action
  schedule = var.policy_any.schedule
}
