
variable "openstack_cloud" {
  description = "Name of the OpenStack cloud to use (from clouds.yaml)"
  type        = string
  default     = "dev" # change as needed or override in terraform.tfvars
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
  type = map(object({
    name            = string
    flavor          = string
    image           = string
    security_groups = list(string)
    volume_size     = optional(number, 10)  
    volume_type       = optional(string)       # optional, future flexibility
    user_data_file    = optional(string)       # optional per-VM init script
    network_name      = optional(string)       # optional network override
    availability_zone = optional(string)       # optional AZ

  }))
}
