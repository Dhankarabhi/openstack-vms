terraform {
  required_version = ">= 1.6.0"
 #abhi
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.0"
    }
  }
}
