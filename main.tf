data "aws_caller_identity" "current" {}

locals {
  repository_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.upstream_registry_name}"
}

data "aws_secretsmanager_secret" "ecr_pullthroughcache" {
  name = "ecr-pullthroughcache/${var.upstream_registry_name}"
}

data "aws_secretsmanager_secret_version" "ecr_pullthroughcache" {
  secret_id = data.aws_secretsmanager_secret.ecr_pullthroughcache.id
}

resource "aws_ecr_pull_through_cache_rule" "ecr_pullthroughcache" {
  ecr_repository_prefix = var.upstream_registry_name
  upstream_registry_url = var.upstream_registry_url
  credential_arn        = data.aws_secretsmanager_secret.ecr_pullthroughcache.arn
}

resource "aws_iam_policy" "ecr_pullthroughcache" {
  name        = "${var.aws_region}-ecr-pullthroughcache-${var.upstream_registry_name}"
  description = "Policy to allow to pull images from ECR pull through cache."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchImportUpstreamImage",
          "ecr:CreateRepository"
        ]
        Resource = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.upstream_registry_name}/*"
      },
    ]
  })

  depends_on = [aws_ecr_pull_through_cache_rule.ecr_pullthroughcache]
}

resource "kubernetes_secret_v1" "secret" {
  for_each = toset(var.fallback_namespaces)

  metadata {
    name      = var.fallback_secret_name
    namespace = each.key
  }
  data = {
    ".dockerconfigjson" = jsonencode(
      {
        "auths" : {
          (var.upstream_registry_url) : {
            "auth" : base64encode(data.aws_secretsmanager_secret_version.ecr_pullthroughcache.secret_string)
          }
        }
      }
    )
  }
  type = "kubernetes.io/dockerconfigjson"
}

resource "aws_ecr_repository_creation_template" "pullthroughcache" {
  count = var.cache_expiration != null ? 1 : 0

  prefix = "ROOT"
  applied_for = [
    "PULL_THROUGH_CACHE",
  ]

  lifecycle_policy = jsonencode({
    "rules": [
      {
        "rulePriority": 1
        "description": "Expire images older than ${var.cache_expiration} days"
        "selection": {
          "tagStatus": "ANY"
          "countType": "sinceImagePushed"
          "countUnit": "days"
          "countNumber": var.cache_expiration
        }
        "action": {
          "type": "expire"
        }
      }
    ]
  })
}
