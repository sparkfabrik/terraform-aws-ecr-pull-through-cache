/*
   # A simple example on how to use this module
 */
module "example" {
  source = "github.com/terraform-aws-ecr-pull-through-cache?ref=0.2.0"

  aws_region = var.aws_region
}
