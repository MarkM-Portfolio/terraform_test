output "arn" {
  description = "The ARN assigned by AWS to the policy"
  value       = aws_iam_policy.policy.arn
}
