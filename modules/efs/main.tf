resource "aws_efs_file_system" "efs" {
  creation_token   = var.efs_name
  encrypted        = var.encrypted
  kms_key_id       = var.kms_key_id
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode

  tags = merge(
    {
      "Name" = var.efs_name
    },
    var.tags
  )
}

resource "aws_efs_mount_target" "efs_mount" {
  count          = length(var.subnet_id) > 0 ? length(var.subnet_id) : 0
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.subnet_id[count.index]
  security_groups = [
    aws_security_group.efs_sg.id
  ]
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.efs_name}-sg"
  description = "EFS Security Group for ${var.efs_name}"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = "${var.efs_name}-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "efs_sg_ingress" {
  for_each          = var.security_group_ingress
  security_group_id = aws_security_group.efs_sg.id
  type              = "ingress"
  description       = lookup(each.value, "description", null)
  from_port         = lookup(each.value, "from_port", null)
  protocol          = lookup(each.value, "protocol", null)
  to_port           = lookup(each.value, "to_port", null)
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.efs.id

  backup_policy {
    status = "ENABLED"
  }
}