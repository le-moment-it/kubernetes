issuers = [
  {
    name                    = "letsencrypt-prod"
    server                  = "https://acme-v02.api.letsencrypt.org/directory"
    email                   = "admin@admin.fr"
    private_key_secret_name = "letsencrypt-prod"
  },
  {
    name                    = "letsencrypt-staging"
    server                  = "https://acme-staging-v02.api.letsencrypt.org/directory"
    email                   = "admin@admin.fr"
    private_key_secret_name = "letsencrypt-staging"
  }
]

vault_api_domain = "vault.stream.vasseurlaurent.com"
