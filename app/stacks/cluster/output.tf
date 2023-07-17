output "docker_registry_url" {
  description = "Docker Registry URL"
  value       = ovh_cloud_project_containerregistry.this.url
}

output "docker_registry_team_user_password" {
  description = "OVH Docker Registry password for user 'team-user'"
  value       = ovh_cloud_project_containerregistry_user.team-user.password
  sensitive   = true
}

output "cluster_api_url" {
  value     = ovh_cloud_project_kube.cluster.kubeconfig_attributes[0].host
  sensitive = true
}

output "docker_registry_k8s_secret_creation_command" {
  description = "Full command to create the secret"
  value       = "kubectl -n my-app create secret docker-registry ovh-docker-reg-cred --docker-server=${ovh_cloud_project_containerregistry.this.url} --docker-username=${ovh_cloud_project_containerregistry_user.team-user.login} --docker-password=${ovh_cloud_project_containerregistry_user.team-user.password} --docker-email=${ovh_cloud_project_containerregistry_user.team-user.email}"
  sensitive   = true
}
