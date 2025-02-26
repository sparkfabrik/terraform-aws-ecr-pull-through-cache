variable "upstream_registry_name" {
  type        = string
  default     = "docker-hub"
  description = "The upstream registry name"
}

variable "upstream_registry_url" {
  type        = string
  default     = "registry-1.docker.io"
  description = "The upstream registry URL"
}

variable "aws_region" {
  type        = string
  default     = "eu-east-1"
  description = "The AWS region to deploy the ECR pull through cache"
}

variable "credentials" {
  type = map(string)
  default = {
    username    = "FILL-ME"
    accessToken = "FILL-ME"
  }
  description = "Upstream registry credentials"
}
