provider "harbor" {
  url = <%= output('cluster.docker_registry_url') %>
  username = "team-user"
  password = <%= output('cluster.docker_registry_team_user_password') %>
}

terraform {
  required_providers {
    harbor = {
      source = "goharbor/harbor"
      version = "3.9.4"
    }
  }
}