output "ecr_pullthroughcache_policy_arn" {
  value       = aws_iam_policy.ecr_pullthroughcache.arn
  description = "The ARN of the ECR pull-through cache policy."
}

output "ecr_pullthroughcache_policy_name" {
  value       = aws_iam_policy.ecr_pullthroughcache.name
  description = "The name of the ECR pull-through cache policy."
}

output "upstream_repository_uri" {
  value       = local.repository_uri
  description = "The URI of the upstream repository."
}
