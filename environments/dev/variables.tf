variable "openstack_cloud" {
  description = "Name of the OpenStack cloud to use (from clouds.yaml)"
  type        = string
  default     = "dev"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "network_name" {
  type        = string
  description = "Existing private network name"
}

variable "external_network_name" {
  type        = string
  description = "External network name (for floating IPs)"
}

variable "keypair_name" {
  type        = string
  description = "SSH keypair name"
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
    
    # Multiple data volumes configuration
    data_volumes = optional(list(object({
      size        = number
      description = optional(string)
      volume_type = optional(string)
      device      = optional(string)
    })), [])
    
    # Other options
    volume_type       = optional(string)
    user_data_file    = optional(string)
    network_name      = optional(string)
    availability_zone = optional(string)
    assign_fip        = optional(bool, false)
  }))
}
