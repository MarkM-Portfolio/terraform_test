data "aws_caller_identity" "current" {}

data "aws_kms_key" "efs" {
  key_id = "alias/aws/elasticfilesystem"
}