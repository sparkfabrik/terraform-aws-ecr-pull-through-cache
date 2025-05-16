# AWS ECR Pull Through cache module

This module creates an ECR (Elastic Container Registry) [pull through cache role](https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-creating-rule.html) resource and the IAM policy to use it.

The pull through cache allows you to cache images from an upstream registry in your ECR repository. This is useful for:
- Reducing the number of requests to the upstream registry
- Improving the performance of image pulls
- Avoiding rate limits

> **Note**: This module **DOES NOT** manage the secret in AWS Secrets Manager, the secret must be created and updated manually.

## Prerequisites

- AWS Secrets Manager secret containing upstream registry credentials

### Quick Start

```hcl
module "ecr_pull_through_cache" {
  source = "github.com/terraform-aws-ecr-pull-through-cache?ref=0.3.0"

  aws_region             = "eu-west-1"
  upstream_registry_name = "docker-hub"
  upstream_registry_url  = "registry-1.docker.io"
}
```

### Upstream credentials

The upstream repository credentials must be created (and managed) manually in AWS Secrets Manager. According to the [AWS documentation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-creating-rule.html#pull-through-cache-creating-rule-secretsmanager):
- The secret must be created in the same AWS account and region as the ECR pull through cache
- The secret name must follow the AWS required naming convention

### IAM Policy

An IAM policy, with the minimum permissions to pull images, is created by the module. You need to attach this IAM policy to the resources that will use the pull through cache.

### Usage Examples

In the following examples you can see how to pull Docker images using the pull through cache using the right image format for the URL:

- for Docker Hub official images: `docker pull AWS_ACCOUNT_ID.dkr.ecr.AWS_REGION.amazonaws.com/docker-hub/library/image_name:tag`.
- For all other Docker Hub images: `docker pull AWS_ACCOUNT_ID.dkr.ecr.AWS_REGION.amazonaws.com/docker-hub/repository_name/image_name:tag`.

For details about other upstream repositories (like Kubernetes, Quay, GitHub, GitLab, etc.), see the [AWS references](https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-working-pulling.html).


### Fallback strategy

This module gives you the option to use a fallback strategy, the upstream credentials (stored in AWS Secret Manager) could be used to populate secrets in the needed namespaces, so you can use it in the ImagePullSecrets of your Kubernetes resources.

### Cache expiration

The module allows you to enable a "since Image Pushed" cache expiration policy, so you can control how long the cached images are kept in the ECR repository.
The default value is `null`, which means that the lifecycle policy is disabled.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy the ECR pull through cache | `string` | `"eu-west-1"` | no |
| <a name="input_cache_expiration"></a> [cache\_expiration](#input\_cache\_expiration) | Number of days to keep cached images. If not set, lifecycle policy is disabled. | `number` | `null` | no |
| <a name="input_fallback_namespaces"></a> [fallback\_namespaces](#input\_fallback\_namespaces) | The list of namespaces to create the regcred secret in | `list(string)` | `[]` | no |
| <a name="input_fallback_secret_name"></a> [fallback\_secret\_name](#input\_fallback\_secret\_name) | The name of the secrets to create | `string` | `"regcred"` | no |
| <a name="input_upstream_registry_name"></a> [upstream\_registry\_name](#input\_upstream\_registry\_name) | The upstream registry name | `string` | `"docker-hub"` | no |
| <a name="input_upstream_registry_url"></a> [upstream\_registry\_url](#input\_upstream\_registry\_url) | The upstream registry URL | `string` | `"registry-1.docker.io"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_pullthroughcache_policy_arn"></a> [ecr\_pullthroughcache\_policy\_arn](#output\_ecr\_pullthroughcache\_policy\_arn) | The ARN of the ECR pull-through cache policy. |
| <a name="output_ecr_pullthroughcache_policy_name"></a> [ecr\_pullthroughcache\_policy\_name](#output\_ecr\_pullthroughcache\_policy\_name) | The name of the ECR pull-through cache policy. |
| <a name="output_ecr_pullthroughcache_repository_uri"></a> [ecr\_pullthroughcache\_repository\_uri](#output\_ecr\_pullthroughcache\_repository\_uri) | The URI of the ECR pull throught cache repository URI. |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_pull_through_cache_rule.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_ecr_repository_creation_template.pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_creation_template) | resource |
| [aws_iam_policy.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubernetes_secret_v1.secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_secretsmanager_secret.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Modules

No modules.

<!-- END_TF_DOCS -->
