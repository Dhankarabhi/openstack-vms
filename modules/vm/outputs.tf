output "vm_floating_ips" {
  description = "Floating IPs of created VMs"
  value = {
    for name, fip in openstack_networking_floatingip_v2.fips :
    name => fip.address
  }
}

output "volumes" {
  description = "Volume names and IDs"
  value = {
    for name, vol in openstack_blockstorage_volume_v3.volumes :
    name => {
      id   = vol.id
      name = vol.name
      size = vol.size
    }
  }
}
