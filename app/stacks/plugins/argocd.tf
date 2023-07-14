resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  timeout    = 600

  values = [
    templatefile("./src/argocd-values.yaml.tftpl",
      {
        host_name               = "stream.vasseurlaurent.com"
        password                = "$2a$10$INYQ5r/p4iqxHJ1kebSQ5uoy/c9KgN5It2y75VVW6kSd6cYsrjysC"
        cluster_issuer_name     = "letsencrypt-prod"
        repo_url                = ""
        repo_username           = "le-moment-it"
        repo_password           = ""
        avp_version             = "1.14.0"
        install_hashicorp_vault = false
        vault_addr              = ""
      }
    )
  ]

  depends_on = [helm_release.ingress-nginx]
}
