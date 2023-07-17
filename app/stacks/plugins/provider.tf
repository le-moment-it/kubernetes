provider "helm" {
  kubernetes {
    config_path = "../../../../cluster.kubeconfig"
  }
}

provider "kubernetes" {
  config_path = "../../../../cluster.kubeconfig"
}

provider "kubectl" {
  load_config_file = true
  config_path      = "../../../../cluster.kubeconfig"
}

provider "tls" {

}
terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}
