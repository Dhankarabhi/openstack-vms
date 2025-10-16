variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "network_name" {
  description = "Existing internal OpenStack network"
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

variable "vms" {
  description = "Map of VMs with specs and optional volume size"
  type = map(object({
    name            = string
    flavor          = string
    image           = string
    security_groups = list(string)
    volume_size     = optional(number, 10)
  }))
}
