data "aws_caller_identity" "current" {}

locals {
  repository_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.upstream_registry_name}"
}

# Create a secret in AWS Secrets Manager to store the upstream registry name.
resource "aws_secretsmanager_secret" "ecr_pullthroughcache" {
  name = "ecr-pullthroughcache/${var.upstream_registry_name}"
}

resource "aws_secretsmanager_secret_version" "ecr_pullthroughcache" {
  secret_id = aws_secretsmanager_secret.ecr_pullthroughcache.id
  secret_string = jsonencode({
    username    = "UPDATE-ME"
    accessToken = "UPDATE-ME"
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_ecr_pull_through_cache_rule" "ecr_pullthroughcache" {
  ecr_repository_prefix = var.upstream_registry_name
  upstream_registry_url = var.upstream_registry_url
  credential_arn        = aws_secretsmanager_secret.ecr_pullthroughcache.arn
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
