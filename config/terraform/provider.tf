provider "ovh" {
  endpoint = "ovh-ca"
}

provider "openstack" {
  auth_url = "https://auth.cloud.ovh.net/v3/"
  alias    = "ovh"
}

provider "template" {

}

terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
    }

    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}
