resource "helm_release" "kube-prometheus" {
  name             = "kube-prometheus-stack"
  namespace        = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [templatefile("./src/prom-grafana-values.yml.tftpl", {
    hostname               = "grafana.stream.vasseurlaurent.com"
    issuer                 = "letsencrypt-prod"
    grafana_admin_password = "laurent"
  })]
}
