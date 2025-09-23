################################# API GATEWAY ##################################

### Creates API Gateway VPC link
resource "aws_api_gateway_vpc_link" "vpc_link" {
  depends_on = [
    helm_release.nginx_ingress,
    #aws_api_gateway_rest_api.rest_api
  ]
  name        = local.api_gateway_name
  description = "VPC link for ${local.cluster_name}. Managed by Terraform."
  target_arns = [data.aws_lb.ingress_lb.id]
  lifecycle {
    ignore_changes = [
      target_arns
    ]
  }

  tags = local.tags
}