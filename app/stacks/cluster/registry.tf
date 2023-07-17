data "ovh_cloud_project_capabilities_containerregistry_filter" "regcap" {
  service_name = local.global_openstack_project_id
  plan_name    = "SMALL"
  region       = "GRA"
}

resource "ovh_cloud_project_containerregistry" "this" {
  name         = "kubernetes"
  service_name = data.ovh_cloud_project_capabilities_containerregistry_filter.regcap.service_name
  plan_id      = data.ovh_cloud_project_capabilities_containerregistry_filter.regcap.id
  region       = data.ovh_cloud_project_capabilities_containerregistry_filter.regcap.region
}

resource "ovh_cloud_project_containerregistry_user" "team-user" {
  service_name = ovh_cloud_project_containerregistry.this.service_name
  registry_id  = ovh_cloud_project_containerregistry.this.id
  email        = "le_moment_it@proton.me"
  login        = "team-user"
}
