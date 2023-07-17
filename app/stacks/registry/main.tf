# This is where you put your resource declaration

resource "harbor_project" "application" {
  name                   = "application"
  public                 = false
  vulnerability_scanning = true
  enable_content_trust   = true
}
