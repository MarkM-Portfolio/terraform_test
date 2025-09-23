# ----- module/eks ------

locals {
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_name       = join("-", [var.tenant_in, var.environment_in, "vpc"])
  cluster_name   = var.cluster_name_in
  nodegroup_name = join("-", [var.tenant_in, var.environment_in, "node"])

  eks_vpc_id = var.create_vpc_in == true ? module.vpc.vpc_id : var.vpc_id_in

  api_gateway_name = join("-", [var.tenant_in, var.environment_in])
  #eks_subnets         = concat(module.vpc.private_subnets, module.vpc.public_subnets) #optional


  argocd_url = var.team != "" ? "argocd-${var.team}-${var.environment_in}.kumuapi.com" : "argocd-${var.environment_in}.kumuapi.com"
  #argocd_url = "argocd-${var.environment_in}.kumuapi.com"

  tags = {
    Environment = var.environment_in
    GithubRepo  = var.github_repo_in
    GithubOrg   = var.github_org_in
    Terraform   = "true"
  }
}
