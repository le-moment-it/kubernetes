variable "issuers" {
  type = list(object({
    name                    = string
    email                   = string
    server                  = string
    private_key_secret_name = string
  }))
  description = "List of issuers to create"
}

variable "vault_api_domain" {
  type        = string
  description = "API domain for vault"
}
