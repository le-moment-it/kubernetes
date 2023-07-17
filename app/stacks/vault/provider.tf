terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }
  }
}

provider "vault" {
  address = <%= output('plugins.vault_api_url') %>
  token   = jsondecode(file("../../../../cluster-keys.json")).root_token
}
