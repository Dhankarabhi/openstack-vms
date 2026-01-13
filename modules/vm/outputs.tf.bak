output "vm_fips" {
  description = "Floating IPs for each VM"
  value = {
    for name, fip in openstack_networking_floatingip_v2.fips :
    name => fip.address
  }
}

output "boot_volumes" {
  description = "Boot volume details for VMs using snapshot/clone"
  value = {
    for name, vol in openstack_blockstorage_volume_v3.boot_volumes :
    name => {
      id   = vol.id
      name = vol.name
      size = vol.size
      type = "boot"
    }
  }
}

output "data_volumes" {
  description = "All data volumes with VM mapping"
  value = {
    for key, vol in openstack_blockstorage_volume_v3.data_volumes :
    key => {
      id          = vol.id
      name        = vol.name
      size        = vol.size
      type        = "data"
      vm_key      = local.data_volumes_flat[key].vm_key
      vm_name     = local.data_volumes_flat[key].vm_name
#      volume_idx  = local.data_volumes_flat[key].vol_idx
      device      = try([for a in vol.attachment : a.device][0], null)
    }
  }
}

output "data_volumes_by_vm" {
  description = "Data volumes grouped by VM"
  value = {
    for vm_key, vm in var.vms :
    vm_key => {
      vm_name = vm.name
      volumes = [
        for vol_key, vol_config in local.data_volumes_flat :
        {
          name   = openstack_blockstorage_volume_v3.data_volumes[vol_key].name
          id     = openstack_blockstorage_volume_v3.data_volumes[vol_key].id
          size   = openstack_blockstorage_volume_v3.data_volumes[vol_key].size
          device = try([for a in openstack_blockstorage_volume_v3.data_volumes[vol_key].attachment : a.device][0], null)
        }
        if vol_config.vm_key == vm_key
      ]
      volume_count = length([
        for vol_key, vol_config in local.data_volumes_flat :
        vol_config if vol_config.vm_key == vm_key
      ])
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
      private_ip  = vm.network[0].fixed_ip_v4

      fip = (
        contains(keys(openstack_networking_floatingip_v2.fips), k)
        ? openstack_networking_floatingip_v2.fips[k].address
        : null
      )

      boot_volume_id = (
        contains(keys(openstack_blockstorage_volume_v3.boot_volumes), k)
        ? openstack_blockstorage_volume_v3.boot_volumes[k].id
        : null
      )

      data_volumes = [
        for vol_key, vol_config in local.data_volumes_flat :
        {
          id     = openstack_blockstorage_volume_v3.data_volumes[vol_key].id
          name   = openstack_blockstorage_volume_v3.data_volumes[vol_key].name
          size   = openstack_blockstorage_volume_v3.data_volumes[vol_key].size
          device = try([for a in openstack_blockstorage_volume_v3.data_volumes[vol_key].attachment : a.device][0], null)
        }
        if vol_config.vm_key == k
      ]

      data_volume_count = length([
        for vol_key, vol_config in local.data_volumes_flat :
        vol_config if vol_config.vm_key == k
      ])
    }
  }
}

output "vm_storage_summary" {
  description = "Storage summary per VM"
  value = {
    for k, vm in openstack_compute_instance_v2.vms :
    k => {
      vm_name = vm.name
      
      boot_method = (
        contains(keys(openstack_blockstorage_volume_v3.boot_volumes), k) 
        ? "snapshot/clone" 
        : "image"
      )
      
      boot_volume_size = (
        contains(keys(openstack_blockstorage_volume_v3.boot_volumes), k)
        ? openstack_blockstorage_volume_v3.boot_volumes[k].size
        : "N/A (image boot)"
      )
      
      data_volumes_count = length([
        for vol_key, vol_config in local.data_volumes_flat :
        vol_config if vol_config.vm_key == k
      ])
      
      data_volumes_total_size = sum([
        for vol_key, vol_config in local.data_volumes_flat :
        openstack_blockstorage_volume_v3.data_volumes[vol_key].size
        if vol_config.vm_key == k
      ])
      
      total_storage = (
        (contains(keys(openstack_blockstorage_volume_v3.boot_volumes), k)
          ? openstack_blockstorage_volume_v3.boot_volumes[k].size
          : 0
        ) +
        sum([
          for vol_key, vol_config in local.data_volumes_flat :
          openstack_blockstorage_volume_v3.data_volumes[vol_key].size
          if vol_config.vm_key == k
        ])
      )
    }
  }
}
