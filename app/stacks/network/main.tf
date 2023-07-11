resource "openstack_networking_router_v2" "this" {
  name                = "kubernetes"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_network_v2" "this" {
  name           = "kubernetes"
  admin_state_up = "true"
  depends_on     = [ovh_vrack_cloudproject.this]
}

resource "openstack_networking_subnet_v2" "private" {
  name            = "private"
  network_id      = openstack_networking_network_v2.this.id
  cidr            = "10.0.1.0/24"
  ip_version      = 4
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]
}

resource "openstack_networking_subnet_v2" "database" {
  name            = "database"
  network_id      = openstack_networking_network_v2.this.id
  cidr            = "10.0.2.0/24"
  ip_version      = 4
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.this.id
  subnet_id = openstack_networking_subnet_v2.private.id
}

