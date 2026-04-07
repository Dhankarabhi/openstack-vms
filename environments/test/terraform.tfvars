###############################################
# Environment
###############################################

environment           = "test"
openstack_cloud       = "dell"
external_network_name = "public1"
keypair_name          = "test"

###############################################
# Network Configuration
###############################################

networks = {
  network_1 = {
    name        = "network-1"
    description = "Main network with multiple subnets"
  }
  network_2 = {
    name        = "network-2"
    description = "Backend / DB / Restricted network"
  }
#  network_3 = {
#    name        =  "network-3"
#    description =  "test"
# }
}
###############################################
# Subnets Configuration
###############################################

subnets = {
  subnet_1 = {
    name        = "subnet-1"
    network_key = "network_1"
    cidr        = "10.10.1.0/24"
    gateway_ip  = "10.10.1.1"
    router_key  = "main_router"
  }

  subnet_2 = {
    name        = "subnet-2"
    network_key = "network_1"
    cidr        = "10.10.2.0/24"
   gateway_ip  = "10.10.2.1"
    router_key  = "main_router"
  }

  subnet_3 = {
    name        = "subnet-3"
    network_key = "network_1"
    cidr        = "10.10.3.0/24"
    gateway_ip  = "10.10.3.1"
    router_key  = "main_router"
  }
#
#  subnet_4 = {
#    name        = "subnet-4"
#    network_key = "network_1"
#    cidr        = "10.10.4.0/24"
#    gateway_ip  = "10.10.4.1"
#    router_key  = "main_router"
#  }
#
#  subnet_5 = {
#    name        = "subnet-5"
#    network_key = "network_1"
#    cidr        = "10.10.5.0/24"
#    gateway_ip  = "10.10.5.1"
#    router_key  = "main_router"
#  }
  subnet_6 = {
    name        = "n-subnet-1"
    network_key = "network_2"
    cidr        = "10.20.1.0/24"
    gateway_ip  = "10.20.1.1"
    router_key  = "main_router"
  }
#  subnet_7 = {
#    name        = "n-subnet-2"
#    network_key = "network_2"
#    cidr        = "10.20.2.0/24"
#    gateway_ip  = "10.20.2.1"
#    router_key  = "main_router"
#  }
#  subnet_8 = {
#    name        = "n-subnet-3"
#    network_key = "network_2"
#    cidr        = "10.20.3.0/24"
#    gateway_ip  = "10.20.3.1"
#    router_key  = "terra_router"
#  }
#  subnet_9 = {
#    name        = "n3-subnet-1"
#    network_key = "network_3"
#    cidr        = "10.30.3.0/24"
#    gateway_ip  = "10.30.3.1"
#    router_key  = "terra_router"
# }
}


###############################################
# Router Configuration
###############################################

routers = {
  main_router = {
    name         = "main-router"
    create       = true
    use_existing = false
  }
 # terra_router = {
 #   name         = "testing"
 #   create       = false
 #   use_existing = true
 # }
  router_new  = { 
    name         = "one-more"
    create       = true
    use_existing = false
  }
}

###############################################
# 🔥 PORTS (THIS WAS MISSING – MOST IMPORTANT)
###############################################

ports = {
  vm1_port = {
    name        = "vm1-port"
    network_key = "network_1"
    subnet_key  = "subnet_1"
    fixed_ip    = null
  }
#  vm1_port_subnet2 = {
#    name        = "vm1-subnet2-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_2"
#  }
#  vm2_port = {
#    name        = "vm2-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_2"
#    fixed_ip    = "10.10.2.50"
#  }
#  vm2_port_subnet2 = {
#    name        = "vm2-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_3"
#    fixed_ip    = "10.10.3.51"
#  }
#
#  vm3_port = {
#    name        = "vm3-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_3"
##    fixed_ip    =  null  
#  }
#
#  vm4_port = {
#    name        = "vm4-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_4"
#    fixed_ip    = "10.10.4.100"
#  }
#
#  vm5_port = {
#    name        = "vm5-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_5"
##    fixed_ip    = null
#  }
#  vm6_port = {
#    name        = "vm6-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_2"
##    fixed_ip    = "10.10.1.100"
#  }
  vm7_port = {
    name        = "vm7-port"
    network_key = "network_1"
    subnet_key  = "subnet_3"
#    fixed_ip    = "10.10.1.100"
  }
  vm8_port = {
    name        = "vm8-port"
    network_key = "network_2"
    subnet_key  = "subnet_6"
    fixed_ip    = "10.20.1.50"
  }
#
#  vm9_port = {
#    name        = "vm9-port"
#    network_key = "network_2"
#    subnet_key  = "subnet_7"
#  }
#  vm10_port = {
#    name        = "vm10-port"
#    network_key = "network_2"
#    subnet_key  = "subnet_8"
#  }
# vm11_port = {
#    name        = "vm11-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_1"
##    fixed_ip    = null
#  }
#  vm11_port_subnet2 = {
#    name        = "vm11-subnet2-port"
#    network_key = "network_1"
#    subnet_key  = "subnet_2"
#  }
# vm12_port = {
#    name        = "vm12-port"
#    network_key = "network_2"
#    subnet_key  = "subnet_8"
#}
# vm12_port_subnet2 = {
#    name        = "vm12-port-sub2"
#    network_key = "network_1"
#    subnet_key  = "subnet_4"
#}
# vm13_port = {
#    name        = "vm13-port"
#    network_key = "network_3"
#    subnet_key  = "subnet_9"
# }
}

###############################################
# Default network for fallback
###############################################

network_name = "network-1"

###############################################
# VMs (NOW PORT-AWARE ✅)
###############################################

vms = {
  vm1 = {
    name            = "web-server-subnet1"
    flavor          = "m1.medium"
    image           = "ubuntu"
    security_groups = ["default", "test-user"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"

    port_keys = ["vm1_port"]

    data_volumes = [
      { size = 30, description = "Web data" }
    ]
  }
#
#  vm2 = {
#    name            = "subnet2-3"
#    flavor          = "m1.medium"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"
#    assign_fip      = true
#    user_data_file  = "../../scripts/user.sh"
#
#    port_keys = ["vm2_port", "vm2_port_subnet2"]
#
#    data_volumes = [
#      { size = 30, description = "App data" }
#    ]
#  }
#
#  vm3 = {
#    name            = "subnet3"
#    flavor          = "m1.large"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"
#    assign_fip      = false
#    user_data_file  = "../../scripts/user.sh"
#
#    port_keys = ["vm3_port"]
#
#    data_volumes = [
#      { size = 100, description = "Database" }
#    ]
#  }
#
#  vm4 = {
#    name            = "subnet4"
#    flavor          = "m1.small"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"
#    assign_fip      = false
#    user_data_file  = "../../scripts/user.sh"
#
#    port_keys = ["vm4_port"]
#
#    data_volumes = [
#      { size = 50, description = "Cache data" }
#    ]
#  }
#
#  vm5 = {
#    name            = "subnet5"
#    flavor          = "m1.medium"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"
#    assign_fip      = true
#    user_data_file  = "../../scripts/user.sh"
#
#    port_keys = ["vm5_port"]
#
#    data_volumes = [
#      { size = 40, description = "Monitoring data" }
#    ]
#  }
  vm7 = {
    name             = "boot-vol"
    flavor           = "m1.medium"
#
    # 🔥 BOOT FROM VOLUME
    boot_snapshot_id = "882d7a0e-23e7-4112-99ba-481f4f1b15ba"
    boot_volume_size = 30

    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
#
    # 🔥 SUBNET PINNING
    port_keys = ["vm7_port"]
#
    data_volumes = [
      { size = 30, description = "Web data" }
    ]
  }
 vm6 = {
    name            = "subnet-22"
    flavor          = "m1.medium"
    image           = "ubuntu"
    security_groups = ["default"]
    keypair         = "test"
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"

    port_keys = ["vm8_port"]
#
#    data_volumes = [
#      { size = 40, description = "Monitoring data" }
#    ]
  }
# vm8 = {
#    name            = "net3"
#    flavor          = "m1.medium"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"
#    assign_fip      = false
#    user_data_file  = "../../scripts/user.sh"
#
#    port_keys = ["vm8_port"]
#
#    data_volumes = [
#      { size = 50, description = "Backend data" }
#    ]
#  }
## vm9 = {
# #   name            = "db-server-net2"
#  #  flavor          = "m1.large"
#   # image           = "ubuntu"
#    #security_groups = ["default"]
#   # keypair         = "test"
#   # assign_fip      = false
#   # user_data_file  = "../../scripts/user.sh"
#   # port_keys = ["vm9_port"]
#   #data_volumes = [
#    # { size = 50, description = "Backend data" }
#  # ]
#
# # }
## vm10 = {
# #   name            = "royer2"
# #   flavor          = "m1.large"
# #   image           = "ubuntu"
# #   security_groups = ["default"]
# #   keypair         = "test"
# #   assign_fip      = false
# #   user_data_file  = "../../scripts/user.sh"
# #   port_keys = ["vm10_port"]
# #   data_volumes = [
#  #    { size = 50, description = "Backend data" }
#   # ]
#
#  #}
## vm11 = {
# #   name            = "web-server-subne1"
# #   flavor          = "m1.medium"
# #   image           = "ubuntu"
# #   security_groups = ["default"]
# #   keypair         = "test"
# #   assign_fip      = false
# #   user_data_file  = "../../scripts/user.sh"
#
#   # port_keys = [
#   #   "vm11_port",
#   #   "vm11_port_subnet2"
#   # ]
#
#  #  data_volumes = [
#  #    { size = 30, description = "Web data" }
#  #  ]
# # }
# vm12 = {
#    name            = "test"
#    flavor          = "m1.large"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"
#    assign_fip      = true
#    user_data_file  = "../../scripts/user.sh"
#    port_keys = ["vm12_port", "vm12_port_subnet2"]
#    data_volumes = [
#      { size = 50, description = "Backend data" }
#    ]
#
#  }
# vm13 = {
#    name            = "net-3"
#    flavor          = "m1.large"
#    image           = "ubuntu"
#    security_groups = ["default"]
#    keypair         = "test"
#    assign_fip      = true
#    user_data_file  = "../../scripts/user.sh"
#    port_keys = ["vm13_port"]
#    data_volumes = [
#      { size = 50, description = "Backend data" }
#    ]
#
#  }
#
}
#
#
