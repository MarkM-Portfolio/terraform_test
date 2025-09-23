variable "environment_in" {
  type = string
}

variable "team" {
  type        = string
  description = "team, sample of which is KDP (Karlito Data Plafortm). setting this will change argocd url with the format argocd-<team>-<environment_in>.kumuapi.com"
  default     = ""
}

variable "tenant_in" {
  type = string
}

variable "create_vpc_in" {}

variable "vpc_cidr_in" {}

variable "vpc_id_in" {}

variable "eks_private_access_in" {}

variable "private_subnets_in" {}

variable "public_subnets_in" {}

variable "private_subnet_ids_in" {}

variable "public_subnet_ids_in" {}

variable "eks_version_in" {
  type = string
}

variable "disk_size_default_in" {
  type = string
}

variable "ami_type_default_in" {
  type = string
}

variable "instance_types_default_in" {}

variable "instance_types_in" {
  type        = list(string)
  description = "Set of instance types associated with the EKS Node Group"
  default     = ["t4g.large"]
}

variable "ssh_key_name_in" {
  type        = string
  description = "SSH key associated with the EKS Node Group"
}

variable "block_device_mappings_in" {
  type        = any
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
}

variable "github_repo_in" {}

variable "github_org_in" {}

####### AWS API GATEWAY VARS #########
#variable "nginx_ingress_nlb_arn_in" {
#}

variable "rancher_hostname_in" {}

variable "regional_certificate_arn_in" {}

variable "domain_name_in" {}

variable "min_size_in" {}

variable "max_size_in" {}

variable "desired_size_in" {}

variable "cluster_name_in" {}

variable "aws_users_in" {}
variable "api_ec2_uri" {}
