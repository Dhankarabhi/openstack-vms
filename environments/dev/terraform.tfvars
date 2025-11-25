environment          = "dev"
network_name         = "demo-net"
external_network_name = "public1"
keypair_name         = "open"
openstack_cloud = "openstack"

vms = {
#  web1 = {
#    name            = "dev-web-1"
#    flavor          = "m1.medium"
#    image           = "xubuntu"
#    security_groups = ["default"]
#    volume_size     = 15
#    user_data_file  = "../../scripts/create_user.sh"
#  }
  web2 = {
    name            = "dev-web-2"
    flavor          = "m1.medium"
    image           = "Ubuntu-24.04-Desktop"
    security_groups = ["default"]
    assign_fip      = true
    volume_size     = 30
  }
  web3 = {
    name            = "dev-web-3"
    flavor          = "m1.medium"
    image           = "Ubuntu-24.04-Desktop"
    security_groups = ["default"]
    volume_size     = 20
    assign_fip      = true
  }
}
