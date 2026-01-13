variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "network_name" {
  description = "Default network name for VMs"
  type        = string
}

variable "external_network_name" {
  description = "External network (for floating IPs)"
  type        = string
}

variable "keypair_name" {
  description = "Keypair for SSH access"
  type        = string
}

# NEW: Accept subnet IDs from network module
variable "subnet_ids" {
  description = "Map of subnet names to IDs (from network module)"
  type        = map(string)
  default     = {}
}
variable "port_id_map" {
  description = "Map of port_keys to port IDs (from network module)"
  type        = map(string)
  default     = {}
}
variable "vms" {
  description = "Map of VMs with flexible boot and storage options"
  type = map(object({
    # Basic VM configuration
    name            = string
    flavor          = string
    security_groups = list(string)
    keypair         = optional(string)
    
    # Boot options (choose ONE)
    image             = optional(string)
    boot_snapshot_id  = optional(string)
    source_volume_id  = optional(string)
    boot_volume_id    = optional(string)
    
    # Boot volume configuration
    boot_volume_size  = optional(number, 50)
    delete_boot_volume_on_termination = optional(bool, false)
    
    # Data volumes
    data_volumes = optional(list(object({
      size        = number
      description = optional(string)
      volume_type = optional(string)
      device      = optional(string)
    })), [])
    
    # Network/Subnet selection (ENHANCED!)
    network_name      = optional(string)       # Per-VM network override
    subnet_name       = optional(string)       # NEW! Specific subnet selection
#    port_ids          = optional(list(string))       # NEW! Use pre-created port
    port_keys         = optional(list(string))  # 🔥 Use this for multi-NIC

    fixed_ip          = optional(string)       # NEW! Specific IP address
    
    # Other options
    volume_type       = optional(string)
    user_data_file    = optional(string)
    availability_zone = optional(string)
    assign_fip        = optional(bool, false)
  }))
  
  validation {
    condition = alltrue([
      for k, vm in var.vms : (
        (try(vm.image, null) != null ? 1 : 0) +
        (try(vm.boot_snapshot_id, null) != null ? 1 : 0) +
        (try(vm.source_volume_id, null) != null ? 1 : 0) +
        (try(vm.boot_volume_id, null) != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Each VM must have exactly ONE boot method."
  }
}
variable "use_existing_network" {
  description = "Whether to attach VMs to an existing network (DEV mode)"
  type        = bool
  default     = false
}
