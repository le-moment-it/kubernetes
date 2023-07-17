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
        host_name               = "argocd.stream.vasseurlaurent.com"
        password                = "$2a$10$INYQ5r/p4iqxHJ1kebSQ5uoy/c9KgN5It2y75VVW6kSd6cYsrjysC"
        cluster_issuer_name     = "letsencrypt-prod"
        repo_url                = "https://github.com/le-moment-it/argocd.git"
        repo_username           = "le-moment-it"
        repo_password           = local.github_token
        avp_version             = "1.14.0"
        install_hashicorp_vault = true
        vault_addr              = "vault.stream.vasseurlaurent.com"
      }
    )
  ]

  depends_on = [helm_release.ingress-nginx]
}

resource "helm_release" "argocd-apps" {

  name = "argocd-apps"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"

  values = [
    templatefile("./src/argocd-apps-values.yaml.tftpl",
      {
        repo_url                = "https://github.com/le-moment-it/argocd.git"
        install_hashicorp_vault = true
      }
    )
  ]

  depends_on = [
    helm_release.argocd
  ]

}
