# This is where you put your resource declaration

resource "ovh_cloud_project_kube" "cluster" {
  service_name = local.global_openstack_project_id
  name         = "cluster"
  region       = "SGP1"

  private_network_id = openstack_networking_network_v2.private_network.id

  private_network_configuration {
    default_vrack_gateway              = "192.168.12.1"
    private_network_routing_as_default = true
  }

  customization_apiserver {
    admissionplugins {
      enabled  = ["NodeRestriction"]
      disabled = ["AlwaysPullImages"]
    }
  }

  depends_on = [openstack_networking_subnet_v2.subnet]
}

resource "ovh_cloud_project_kube_nodepool" "node_pool" {
  service_name  = local.global_openstack_project_id
  name          = "pool"
  kube_id       = ovh_cloud_project_kube.cluster.id
  flavor_name   = "b2-7"
  desired_nodes = 3
  max_nodes     = 3
  min_nodes     = 3

  timeouts {
    create = "1h"
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content         = ovh_cloud_project_kube.cluster.kubeconfig
  filename        = "../../../../cluster.kubeconfig"
  file_permission = "0640"

  depends_on = [ovh_cloud_project_kube.cluster, ovh_cloud_project_kube_nodepool.node_pool]
}
