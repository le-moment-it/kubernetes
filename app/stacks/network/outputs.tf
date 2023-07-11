output "network_name" {
  value = openstack_networking_network_v2.this.name
}

output "network_id" {
  value = openstack_networking_network_v2.this.id
}

output "subnet_private_id" {
  value = openstack_networking_subnet_v2.private.id
}
