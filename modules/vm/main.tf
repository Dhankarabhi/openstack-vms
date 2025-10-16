terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.52.1"
    }
  }
}

###############################################
# VM Module — with Floating IP + Volume
###############################################

# Get existing network
data "openstack_networking_network_v2" "existing" {
  name = var.network_name
}

# Get external network for floating IPs
data "openstack_networking_network_v2" "external" {
  name = var.external_network_name
}

# Create VMs
resource "openstack_compute_instance_v2" "vms" {
  for_each = var.vms

  name            = each.value.name
  flavor_name     = each.value.flavor
  image_name      = each.value.image
  key_pair        = var.keypair_name
  security_groups = each.value.security_groups

  network {
    uuid = data.openstack_networking_network_v2.existing.id
  }

  # Run SSH setup script
  #user_data = file("${path.module}/../../scripts/setup_ssh_user.sh")
  user_data = file("${path.module}/../../scripts/user_data.sh")
#  user_data = join("\n", [
#  file("${path.module}/../../scripts/setup_openssh.sh"),
#  file("${path.module}/../../scripts/setup_ssh_user.sh"),
#  file("${path.module}/../../scripts/setup_ssh_all.sh")
#])

  metadata = {
    environment = var.environment
  }
}

###############################################
# Volume attachment (per VM)
###############################################
resource "openstack_blockstorage_volume_v3" "volumes" {
  for_each = var.vms

  name        = "${each.value.name}-volume"
  size        = lookup(each.value, "volume_size", 10)
  description = "Attached volume for ${each.value.name}"
}

resource "openstack_compute_volume_attach_v2" "attach" {
  for_each    = var.vms
  instance_id = openstack_compute_instance_v2.vms[each.key].id
  volume_id   = openstack_blockstorage_volume_v3.volumes[each.key].id
}

###############################################
# Floating IP assignment
###############################################
resource "openstack_networking_floatingip_v2" "fips" {
  for_each = var.vms
  pool     = data.openstack_networking_network_v2.external.name
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  for_each       = var.vms
  floating_ip    = openstack_networking_floatingip_v2.fips[each.key].address
  instance_id    = openstack_compute_instance_v2.vms[each.key].id
  depends_on     = [openstack_compute_instance_v2.vms]
}

###############################################
# Outputs
###############################################
output "vm_ips" {
  description = "VM names and Floating IPs"
  value = {
    for name, fip in openstack_networking_floatingip_v2.fips :
    name => fip.address
  }
}

output "volume_ids" {
  description = "Volume IDs attached to VMs"
  value = {
    for name, vol in openstack_blockstorage_volume_v3.volumes :
    name => vol.id
  }
}
