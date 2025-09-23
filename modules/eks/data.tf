### Used for api gateway section ####
data "aws_availability_zones" "available" {
}

data "aws_lb" "ingress_lb" {
  depends_on = [module.eks, helm_release.nginx_ingress]
  tags = {
    "kubernetes.io/service-name"                  = "ingress-nginx/nginx-ingress-controller-nginx-ingress",
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = module.eks.cluster_id
}

data "aws_kms_key" "ebs" {
  key_id = "alias/aws/ebs"
}