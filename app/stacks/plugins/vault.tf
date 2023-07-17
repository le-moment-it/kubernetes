resource "tls_private_key" "ca" {

  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_self_signed_cert" "ca" {

  #key_algorithm         = tls_private_key.ca.algorithm
  private_key_pem       = tls_private_key.ca.private_key_pem
  is_ca_certificate     = true
  validity_period_hours = "168"

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature"
  ]

  subject {
    organization = "HashiCorp (NonTrusted)"
    common_name  = "HashiCorp (NonTrusted) Private Certificate Authority"
    country      = "CA"
  }
}

#------------------------------------------------------------------------------
# Certificate
#------------------------------------------------------------------------------
resource "tls_private_key" "vault_private_key" {

  algorithm   = "RSA"
  ecdsa_curve = "P384"
  rsa_bits    = "2048"
}

resource "tls_cert_request" "vault_cert_request" {

  #key_algorithm   = tls_private_key.vault_private_key.algorithm
  private_key_pem = tls_private_key.vault_private_key.private_key_pem

  dns_names = [for i in range(3) : format("hashicorp-vault-%s.hashicorp-vault-internal", i)]

  subject {
    common_name  = "HashiCorp Vault Certificate"
    organization = "HashiCorp Vault Certificate"
  }
}

resource "tls_locally_signed_cert" "vault_signed_certificate" {

  cert_request_pem   = tls_cert_request.vault_cert_request.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = "168"

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]
}

resource "kubernetes_secret" "tls" {
  metadata {
    name      = "tls"
    namespace = "hashicorp-vault"
  }

  data = {
    "tls.crt" = tls_locally_signed_cert.vault_signed_certificate.cert_pem
    "tls.key" = tls_private_key.vault_private_key.private_key_pem
  }

  type = "kubernetes.io/tls"

  depends_on = [
    kubernetes_namespace.hashicorp-vault
  ]
}

resource "kubernetes_secret" "tls_ca" {
  metadata {
    name      = "tls-ca"
    namespace = "hashicorp-vault"
  }

  data = {
    "ca.crt" = tls_self_signed_cert.ca.cert_pem
  }

  depends_on = [
    kubernetes_namespace.hashicorp-vault
  ]
}

# -------------------------------------------


resource "kubernetes_namespace" "hashicorp-vault" {
  metadata {
    name = "hashicorp-vault"
  }
  depends_on = [helm_release.ingress-nginx]
}

resource "helm_release" "hashicorp-vault" {
  name      = "hashicorp-vault"
  namespace = "hashicorp-vault"

  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"

  values = [templatefile("./src/vault-values.yml", {
    kubernetes_secret_name_tls_ca    = kubernetes_secret.tls_ca.metadata.0.name
    kubernetes_secret_name_tls_cert  = kubernetes_secret.tls.metadata.0.name
    kubernetes_vault_ui_service_type = "LoadBalancer"

    vault_data_storage_size     = "10"
    vault_leader_tls_servername = null
    vault_seal_method           = "shamir"
    vault_ui                    = true

    cluster_issuer_name         = "letsencrypt-prod"
    vault_server_hostname       = var.vault_api_domain
    enable_vault_server_ingress = true
  })]

  depends_on = [
    kubernetes_namespace.hashicorp-vault
  ]
}
