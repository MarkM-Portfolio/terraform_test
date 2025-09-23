output "node_sg" {
  value       = module.eks.node_security_group_id
  description = "The security group of the created nodegroup"
}

output "argocd_url" {
  value       = local.argocd_url
  description = "URL for ArgoCD"
}


output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "eks_oidc_provider" {
  value = module.eks.oidc_provider
}

# output "eks_api_gw_id" {
#   value = aws_api_gateway_rest_api.rest_api.id
# }

# output "eks_api_gw_root_id" {
#   value = aws_api_gateway_rest_api.rest_api.root_resource_id
# }

# output "eks_api_vpc_link_method" {
#   value = aws_api_gateway_method.vpc_link_method.http_method
# }

output "eks_api_vpc_link_id" {
  value = aws_api_gateway_vpc_link.vpc_link.id
}
