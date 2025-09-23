resource "aws_api_gateway_rest_api" "this" {


  name        = var.params.name
  body        = file("openapi_files/${var.params.openapi_config}")
  description = "API Gateway for ${var.params.name}. Managed by Terraform. Refactored API Gateway"

  endpoint_configuration {
    types = [var.params.endpoint_config]
  }

  tags = {}
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.params.name
  tags          = {}
  variables     = {}
}

resource "aws_api_gateway_domain_name" "this" {
  domain_name              = var.params.custom_domain_name
  regional_certificate_arn = var.params.acm_arn
  security_policy          = "TLS_1_2"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  depends_on  = [aws_api_gateway_domain_name.this]
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this.domain_name
}