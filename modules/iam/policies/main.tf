resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  path        = var.path
  description = var.description

  policy = var.policy

  tags = var.tags
}
