environment          = "dev"
network_name         = "terraform"
external_network_name = "public1"
keypair_name         = "openstack"
openstack_cloud = "mycloud"

vms = {
  web1 = {
    name            = "open-vpn"
    flavor          = "m1.medium"
    image           = "Ubuntu-24.04LTS-Server"
#    security_groups = ["default"]
    security_groups = ["default", "open-vpn"]
    keypair         = "terraform"
    volume_size     = 10
    assign_fip      = true
    user_data_file  = "../../scripts/user.sh"
  }
  web2 = {
    name            = "wazuh-master-1"
    flavor          = "m1.large"
    image           = "Ubuntu-24.04LTS-Server"
    security_groups = ["default"]
    assign_fip      = false
    volume_size     = 50
    keypair         = "terraform"
    user_data_file  = "../../scripts/user.sh"

  }
  web3 = {
    name            = "wazuh-worker-1"
    flavor          = "m1.large"
    image           = "Ubuntu-24.04LTS-Server"
    security_groups = ["default"]
    keypair         = "terraform"   
    volume_size     = 50
    user_data_file  = "../../scripts/user.sh"
    assign_fip      = false
  }

  web4 = {
    name            = "wazuh-worker-2"
    flavor          = "m1.large"
    image           = "Ubuntu-24.04LTS-Server"
    security_groups = ["default"]
    keypair         = "terraform"
    volume_size     = 50
    assign_fip      = false
    user_data_file  = "../../scripts/user.sh"

  }
  web5 = {
    name            = "wazuh-worker-3"
    flavor          = "m1.large"
    image           = "Ubuntu-24.04LTS-Server"
    security_groups = ["default"]
    keypair         = "terraform"  
    volume_size     = 50
    user_data_file  = "../../scripts/user.sh"
    assign_fip      = false
 
  }
  web6 = {
    name            = "wazuh-worker-4"
    flavor          = "m1.large"
    image           = "Ubuntu-24.04LTS-Server"
    security_groups = ["default"]
    keypair         = "terraform"
    volume_size     = 50
    assign_fip      = false
    user_data_file  = "../../scripts/user.sh"
 
  }
  web7 = {
    name            = "docker-center"
    flavor          = "m1.large"
    image           = "Ubuntu-24.04LTS-Server"
    security_groups = ["default"]
    volume_size     = 10
    keypair         = "terraform"
    assign_fip      = false
    user_data_file  = "../../scripts/user.sh"

 }

# web4 = {
#    name              = "dev-web-4"
#    flavor            = "m1.medium"
#    boot_from_volume  = true                           
#    boot_volume_id    = "f698d3fe-830a-4cee-9911-2208c3444111"          
#    security_groups   = ["default"]
#    keypair           = "openstack"
#    volume_size       = 40
#    assign_fip        = false
#  }
}
