/*
   # A simple example on how to use this module
 */
module "example" {
  source  = "github.com/terraform-aws-ecr-pull-through-cache"
  version = ">= 0.1.0"

  aws_region = var.aws_region
}
