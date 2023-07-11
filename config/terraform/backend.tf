terraform {
  backend "s3" {
    bucket                      = "moment-it-kubernetes"
    key                         = "<%= expansion(':TYPE_DIR/:APP/:ROLE/:MOD_NAME/:ENV/:EXTRA/:REGION/terraform.tfstate') %>"
    region                      = "gra"
    skip_credentials_validation = true
    skip_region_validation      = true
    endpoint                    = "https://s3.gra.io.cloud.ovh.net/"
  }
}
