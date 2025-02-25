/*
   # A simple example on how to use this module
 */
module "example" {
  source  = "github.com/sparkfabrik/terraform-module-template"
  version = ">= 0.1.0"

  name = var.name
}
