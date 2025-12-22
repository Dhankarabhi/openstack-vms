###############################################
# Environment Variables
###############################################

variable "openstack_cloud" {
  description = "Name of the OpenStack cloud to use (from clouds.yaml)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/test/prod)"
  type        = string
}

variable "network_name" {
  description = "Default network name for VMs (fallback)"
  type        = string
}

variable "external_network_name" {
  description = "External network name (for floating IPs)"
  type        = string
}

variable "keypair_name" {
  description = "SSH keypair name"
  type        = string
}

###############################################
# Network Module Variables
###############################################

variable "networks" {
  description = "Map of networks to create"
  type = map(object({
    name                  = string
    description           = optional(string)
    admin_state_up        = optional(bool, true)
    mtu                   = optional(number)
    port_security_enabled = optional(bool)
    tags                  = optional(list(string), [])
  }))
  default = {}
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    name             = string
    network_key      = string
    cidr             = string
    ip_version       = optional(number, 4)
    enable_dhcp      = optional(bool, true)
    gateway_ip       = optional(string)
    no_gateway       = optional(bool, false)
    dns_nameservers  = optional(list(string), [])
    router_key       = optional(string)
  }))
  default = {}
}

###############################################
# Routers
###############################################

variable "routers" {
  description = "Map of routers (create new or use existing)"
  type = map(object({
    name         = string
    create       = optional(bool, true)
    use_existing = optional(bool, false)
  }))
  default = {}
}

###############################################
# Neutron Ports (Subnet-specific placement)
###############################################

variable "ports" {
  description = "Neutron ports for subnet-specific VM placement"
  type = map(object({
    name            = string
    network_key     = string
    subnet_key      = string
    fixed_ip        = optional(string)
    security_groups = optional(list(string), [])
  }))
  default = {}
}

###############################################
# VM Variables (FULLY COMPATIBLE WITH VM MODULE)
###############################################

variable "vms" {
  description = "Map of VMs with flexible boot, storage and networking"
  type = map(object({
    # Basic
    name            = string
    flavor          = string
    security_groups = list(string)
    keypair         = optional(string)

    # 🔥 Boot options (EXACTLY ONE REQUIRED)
    image             = optional(string)
    boot_snapshot_id  = optional(string)
    source_volume_id  = optional(string)
    boot_volume_id    = optional(string)

    # Boot volume config
    boot_volume_size  = optional(number, 50)
    delete_boot_volume_on_termination = optional(bool, false)

    # Data volumes
    data_volumes = optional(list(object({
      size        = number
      description = optional(string)
      volume_type = optional(string)
      device      = optional(string)
    })), [])

    # Networking
    port_keys     = optional(list(string))   # preferred (from network module)
    network_name = optional(string)   # fallback
    subnet_name  = optional(string)
    fixed_ip     = optional(string)

    # Other
    assign_fip     = optional(bool, false)
    user_data_file = optional(string)
    availability_zone = optional(string)
  }))

  ###############################################
  # VALIDATION — DO NOT REMOVE
  ###############################################
  validation {
    condition = alltrue([
      for k, vm in var.vms : (
        (try(vm.image, null) != null ? 1 : 0) +
        (try(vm.boot_snapshot_id, null) != null ? 1 : 0) +
        (try(vm.source_volume_id, null) != null ? 1 : 0) +
        (try(vm.boot_volume_id, null) != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Each VM must have exactly ONE boot method (image OR snapshot OR volume)."
  }
}
