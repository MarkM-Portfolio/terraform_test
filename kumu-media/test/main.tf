#------root/main.tf--------

module "aws_eks" {
  source = "../../modules/eks" #make this more appropriate path

  ##General variables
  environment_in  = local.environment
  tenant_in       = local.tenant
  cluster_name_in = local.cluster_name

  ##VPC variables
  create_vpc_in         = local.create_vpc
  vpc_cidr_in           = local.vpc_cidr
  vpc_id_in             = local.vpc_id
  private_subnets_in    = local.private_subnets
  public_subnets_in     = local.public_subnets
  private_subnet_ids_in = local.private_subnet_ids
  public_subnet_ids_in  = local.public_subnet_ids

  ##EKS variables
  eks_version_in        = local.eks_version
  eks_private_access_in = local.eks_private_access

  github_repo_in = local.github_repo
  github_org_in  = local.github_org

  #default node group variables
  ami_type_default_in       = local.ami_type_default
  disk_size_default_in      = local.disk_size_default
  instance_types_default_in = local.instance_types_default
  instance_types_in         = local.instance_types
  max_size_in               = local.max_size
  min_size_in               = local.min_size
  desired_size_in           = local.desired_size
  block_device_mappings_in  = local.block_device_mappings
  ssh_key_name_in           = local.ssh_key_name


  rancher_hostname_in = local.rancher_hostname

  regional_certificate_arn_in = local.regional_certificate_arn
  domain_name_in              = local.domain_name

  # auth configmap variables
  aws_users_in = local.aws_users

  # eks api gateway
  api_ec2_uri = local.ec2_server_url

}

# module "aws_sg" {
#   depends_on = [module.aws_eks]
#   source     = "../../modules/aws_sg" #make this more appropriate path

#   cluster_name_in                 = local.cluster_name
#   rds_security_group_id_in        = local.rds_security_group_id
#   redis_security_group_id_in      = local.redis_security_group_id
#   opensearch_security_group_id_in = local.opensearch_security_group_id

#   source_security_group_id_in = module.aws_eks.node_sg
# }

#module "aws_guardduty" {
#  source       = "../../modules/guardduty"
#}

# module "efs" {
#   source                 = "../../modules/efs"
#   environment            = local.environment
#   efs_name               = local.efs_name
#   encrypted              = true
#   kms_key_id             = data.aws_kms_key.efs.arn #AWS managed KMS key for EFS
#   performance_mode       = local.performance_mode
#   throughput_mode        = local.throughput_mode
#   security_group_ingress = local.security_group_ingress
#   vpc_id                 = local.vpc_id
#   subnet_id              = local.private_subnet_ids

#   tags = {
#     Terraform   = "true"
#     Environment = local.environment
#   }

# }

# module "api_gateway_v2" {
#   for_each = local.api_gateways_v2

#   source = "../../modules/api-gateway-v2"
#   params = each.value
# }
