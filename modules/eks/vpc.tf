module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = var.create_vpc_in
  name       = local.vpc_name
  cidr       = var.vpc_cidr_in ####10.30.0.0/16 <- for dev
  azs        = local.azs

  ####make this a variable/local that references moduke.vpc.cidr
  private_subnets = var.private_subnets_in ## [ x.x.0.0/20, x.x.16.0/20, x.x.32.0/20] 
  public_subnets  = var.public_subnets_in  ## [ x.x.128.0/20, x.x.144.0/20, x.x.160.0/20]

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "karpenter.sh/discovery" = local.cluster_name
  }

  enable_vpn_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true

  tags = {
    Terraform   = "true"
    Environment = var.environment_in
  }

  vpc_tags = {
    Name = local.vpc_name
  }
}