###############################################
# Developer Environment Configuration
###############################################

environment           = "developer"
openstack_cloud       = "dell"
external_network_name = "public1"
keypair_name          = "test"

###############################################
# 🔥 SCENARIO 1: Use test's network + router
###############################################
use_existing_networks = {
  network_1 = {
    name = "network-1"  # ✅ Created in test env
  }
  network_2 = {
    name = "terraform"  # ✅ Created in test env
  }
}

use_existing_routers = {
  main_router = {
    name = "main-router"  # ✅ Created in test env
  }
  prod_router = {
    name = "terra-router"  # ✅ Created in test env
  }
}

###############################################
# 🔥 SCENARIO 2: Optionally import test's subnets
# (Uncomment if you want to use existing subnets)
###############################################
# use_existing_subnets = {
#   test_subnet_1 = {
#     name = "subnet-1"  # ✅ From test env
#   }
# }

###############################################
# 🔥 CREATE NEW SUBNETS in test's network
###############################################
subnets = {
  dev_subnet_1 = {
    name        = "developer-subnet-1"
    network_key = "network_1"  # ✅ References imported network
    cidr        = "10.10.100.0/24"
    gateway_ip  = "10.10.100.1"
    router_key  = "main_router"  # ✅ References imported router
  }
  
  dev_subnet_2 = {
    name        = "developer-subnet-2"
    network_key = "network_1"
    cidr        = "10.10.101.0/24"
    gateway_ip  = "10.10.101.1"
    router_key  = "main_router"
  }
  
  dev_subnet_3 = {
    name        = "developer-subnet-3"
    network_key = "network_1"
    cidr        = "10.10.102.0/24"
    gateway_ip  = "10.10.102.1"
    router_key  = "main_router"
  }
 prod_subnet_1 = {
    name        = "prod-subnet-1"
    network_key = "network_2"  # ✅ References imported network
    cidr        = "10.0.1.0/24"
    gateway_ip  = "10.0.1.1"
    router_key  = "prod_router"  # ✅ References imported router
  }

}

###############################################
# 🔥 CREATE PORTS in new subnets
###############################################
ports = {
  dev_vm1_port = {
    name        = "dev-vm1-port"
    network_key = "network_1"
    subnet_key  = "dev_subnet_1"
    fixed_ip    = "10.10.100.50"
  }
# dev_vm1-2_port = {
#    name        = "dev-vm1-2-port"
#    network_key = "network_1"
#    subnet_key  = "dev_subnet_2"
#    fixed_ip    = "10.10.100.50"
#  }

 dev_vm5_port = {
    name        = "dev-vm5-port"
    network_key = "network_1"
    subnet_key  = "dev_subnet_1"
  #  fixed_ip    = "10.10.100.50"
  }

  
  dev_vm2_port = {
    name        = "dev-vm2-port"
    network_key = "network_2"
    subnet_key  = "prod_subnet_1"
  }
 dev_vm2_port_2 = {
    name        = "dev-vm2-port_2"
    network_key = "network_1"
    subnet_key  = "dev_subnet_1"
  }
  
  dev_vm3_port = {
    name        = "dev-vm3-port"
    network_key = "network_1"
    subnet_key  = "dev_subnet_3"
    fixed_ip    = "10.10.102.100"
  }
  
  # Multi-NIC example
  dev_vm4_port1 = {
    name        = "dev-vm4-port-subnet1"
    network_key = "network_1"
    subnet_key  = "dev_subnet_1"
  }
  
  dev_vm4_port2 = {
    name        = "dev-vm4-port-subnet2"
    network_key = "network_1"
    subnet_key  = "dev_subnet_2"
  }
}

###############################################
# Default network for fallback
###############################################
network_name = "network-1"

###############################################
# VMs - Using new subnets in test's network
###############################################
vms = {
  dev_vm1 = {
    name            = "developer-sub-1"
    flavor          = "m1.medium"
    image           = "ubuntu"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
    
    port_keys = ["dev_vm1_port"]
    
  #  data_volumes = [
  #    { size = 30, description = "Dev web data" }
  #  ]
  }
  
  dev_vm2 = {
    name            = "developer-sub-2"
    flavor          = "m1.medium"
    image           = "ubuntu"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
    
    port_keys = ["dev_vm2_port", "dev_vm2_port_2"]
    
  #  data_volumes = [
  #    { size = 50, description = "Dev app data" }
  #  ]
  }
  
  dev_vm3 = {
    name            = "developer-sub-3"
    flavor          = "m1.large"
    image           = "ubuntu"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = false
    user_data_file  = "../../scripts/user.sh"
    
    port_keys = ["dev_vm3_port"]
    
#    data_volumes = [
#      { size = 100, description = "Dev database" }
#    ]
  }
  
  # 🔥 Multi-NIC VM (connected to 2 subnets)
  dev_vm4 = {
    name            = "developer-sub-1-2"
    flavor          = "m1.medium"
    image           = "ubuntu"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
    
    port_keys = ["dev_vm4_port1", "dev_vm4_port2"]  # ✅ Multi-subnet
    
    #data_volumes = [
    #  { size = 40, description = "Multi-nic data" }
    #]
  }
  
  # 🔥 Boot from snapshot example
  dev_vm5 = {
    name             = "developer-sub-1-snap"
    flavor           = "m1.large"
    
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 50
    
    security_groups  = ["default"]
    keypair          = "test"
    assign_fip       = true
    user_data_file   = "../../scripts/user.sh"
    
    port_keys = ["dev_vm5_port"]
    
    data_volumes = [
      { size = 10, description = "Snapshot VM data" }
    ]
  }
}

###############################################
# 🔥 We DON'T create new networks/routers
# Because we're using test's infrastructure
###############################################
networks = {}
routers  = {}
