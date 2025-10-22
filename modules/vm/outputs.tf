output "vm_fips" {
  description = "Floating IPs for each VM"
  value = {
    for name, fip in openstack_networking_floatingip_v2.fips :
    name => fip.address
  }
}

output "volumes" {
  description = "Volume details attached to each VM"
  value = {
    for name, vol in openstack_blockstorage_volume_v3.volumes :
    name => {
      id   = vol.id
      name = vol.name
      size = vol.size
    }
  }
}

output "vm_details" {
  description = "Comprehensive VM information"
  value = {
    for k, vm in openstack_compute_instance_v2.vms :
    k => {
      id          = vm.id
      name        = vm.name
      flavor      = vm.flavor_name
      power_state = vm.power_state
      fip         = openstack_networking_floatingip_v2.fips[k].address
      volume_id   = openstack_blockstorage_volume_v3.volumes[k].id
    }
  }
}
