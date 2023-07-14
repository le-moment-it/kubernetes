data "openstack_networking_network_v2" "ext_net" {
  name   = "Ext-Net"
  region = "SGP1"
}

resource "openstack_networking_network_v2" "private_network" {
  name           = "private-network"
  region         = "SGP1"
  admin_state_up = "true"
  depends_on     = [ovh_vrack_cloudproject.this]
}

resource "openstack_networking_subnet_v2" "subnet" {
  network_id      = openstack_networking_network_v2.private_network.id
  region          = "GRA9"
  name            = "subnet"
  cidr            = "192.168.12.0/24"
  enable_dhcp     = true
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]

  allocation_pool {
    start = "192.168.12.100"
    end   = "192.168.12.254"
  }
}

resource "openstack_networking_router_v2" "router" {
  region              = "SGP1"
  name                = "router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  region    = "SGP1"
  subnet_id = openstack_networking_subnet_v2.subnet.id
}
