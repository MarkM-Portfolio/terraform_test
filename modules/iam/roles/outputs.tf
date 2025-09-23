output "arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.role.arn
}

output "name" {
  description = "Name of IAM role"
  value       = aws_iam_role.role.name
}

