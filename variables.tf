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
  default     = "eu-west-1"
  description = "The AWS region to deploy the ECR pull through cache"
}

variable "fallback_namespaces" {
  type = list(string)
  description = "The list of namespaces to create the regcred secret in"
  default = []
}

variable "fallback_secret_name" {
  type        = string
  default     = "regcred"
  description = "The name of the secrets to create"
}

variable "enable_cache_lifecycle" {
  type        = bool
  description = "Enable cache lifecycle."
  default     = false
}
