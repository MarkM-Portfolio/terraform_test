###
resource "aws_security_group_rule" "rds_sg" {
  #  depends_on               = [module.aws_eks]
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = var.rds_security_group_id_in
  source_security_group_id = var.source_security_group_id_in
  description              = "terraform created rule for ${var.cluster_name_in}"
}

resource "aws_security_group_rule" "redis_sg" {
  #  depends_on               = [module.aws_eks]
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = var.redis_security_group_id_in
  source_security_group_id = var.source_security_group_id_in
  description              = "terraform created rule for ${var.cluster_name_in}"
}

resource "aws_security_group_rule" "opensearch_sg_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = var.opensearch_security_group_id_in
  source_security_group_id = var.source_security_group_id_in
  description              = "terraform created rule for ${var.cluster_name_in}"
}

resource "aws_security_group_rule" "opensearch_sg_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = var.opensearch_security_group_id_in
  source_security_group_id = var.source_security_group_id_in
  description              = "terraform created rule for ${var.cluster_name_in}"
}