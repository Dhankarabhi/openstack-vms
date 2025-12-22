###############################################
# Network Module Variables
###############################################

variable "external_network_name" {
  description = "External provider network name"
  type        = string
}

variable "networks" {
  type = map(object({
    name           = string
    description    = optional(string)
    admin_state_up = optional(bool, true)
  }))
  default = {}
}

variable "subnets" {
  type = map(object({
    name            = string
    network_key     = string
    cidr            = string
    ip_version      = optional(number, 4)
    enable_dhcp     = optional(bool, true)
    gateway_ip      = optional(string)
    no_gateway      = optional(bool, false)
    dns_nameservers = optional(list(string), [])
    router_key      = optional(string)
  }))
  default = {}
}

variable "routers" {
  type = map(object({
    name         = string
    create       = optional(bool, true)
    use_existing = optional(bool, false)
  }))
  default = {}
}

###############################################
# 🔥 PORTS (UPDATED – subnet_key OPTIONAL)
###############################################
variable "ports" {
  description = "Neutron ports for subnet-specific VM placement"
  type = map(object({
    name            = string
    network_key     = string
    subnet_key      = string   # ✅ FIXED
    fixed_ip        = optional(string)
    security_groups = optional(list(string), [])
  }))
  default = {}
}
