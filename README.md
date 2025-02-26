# AWS ECR Pull Through cache module

This module creates an ECR (Elastic Container Registry) [pull through cache role](https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-creating-rule.html) resource and all the resources necessary to use it.
### Upstream credentials

The upstream repository credentials must be stored in an AWS Secrets Manager secret.

The secret, with a dummy values, is created by the module with the same name as `upstream_registry` variable value plus an AWS prefix. You need to update the secret with the real credentials. :warning: **ATTENTION:** this module ignores any changes for the secret value. The secret should be filled in manually in order to keep the secret value private.


### IAM Policy

An IAM policy, with the mimimum permissions to pull images, is created by the module, attach this IAM policy to the resources that will use the pull through cache.


## Pull through cache usage

To pull Docker images, for example,  with pull through cache, you must use the following image format url:

- For Docker Hub official images: `docker pull AWS_ACCOUNT_ID.dkr.ecr.AWS_REGION.amazonaws.com/docker-hub/library/image_name:tag`
- For all other Docker Hub images: `docker pull AWS_ACCOUNT_ID.dkr.ecr.AWS_REGION.amazonaws.com/docker-hub/repository_name/image_name:tag`

Details about other upstream repositories (like Kubernetes, Quay, GitHub, GitLab..) see the [AWS references](https://docs.aws.amazon.com/AmazonECR/latest/userguide/pull-through-cache-working-pulling.html)


<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy the ECR pull through cache | `string` | `"eu-east-1"` | no |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | Upstream registry credentials | `map(string)` | <pre>{<br/>  "accessToken": "FILL-ME",<br/>  "username": "FILL-ME"<br/>}</pre> | no |
| <a name="input_upstream_registry"></a> [upstream\_registry](#input\_upstream\_registry) | The upstream registry name | `string` | `"docker-hub"` | no |
| <a name="input_upstream_registry_url"></a> [upstream\_registry\_url](#input\_upstream\_registry\_url) | The upstream registry URL | `string` | `"registry-1.docker.io"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_pullthroughcache_policy_arn"></a> [ecr\_pullthroughcache\_policy\_arn](#output\_ecr\_pullthroughcache\_policy\_arn) | The name of the resource. |
| <a name="output_ecr_pullthroughcache_policy_name"></a> [ecr\_pullthroughcache\_policy\_name](#output\_ecr\_pullthroughcache\_policy\_name) | The name of the resource. |

## Resources

| Name | Type |
|------|------|
| [aws_ecr_pull_through_cache_rule.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_pull_through_cache_rule) | resource |
| [aws_iam_policy.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_secretsmanager_secret.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.ecr_pullthroughcache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Modules

No modules.

<!-- END_TF_DOCS -->
