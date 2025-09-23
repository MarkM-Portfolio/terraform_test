################################# API GATEWAY ##################################
### Creates API Gateway resource
resource "aws_api_gateway_rest_api" "rest_api_v2" {
  #depends_on = [time_sleep.wait_5_mins]
  for_each = var.api_gateways_in
  #name        = "segment-tracker"
  name = each.value.name

  description = each.value.description

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  #tags = local.tags #change this
}

### Creates ANY method in API Gateway
resource "aws_api_gateway_method" "vpc_link_method_v2" {
  depends_on = [
    aws_api_gateway_rest_api.rest_api_v2
  ]
  for_each = var.api_gateways_in

  rest_api_id   = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  resource_id   = aws_api_gateway_rest_api.rest_api_v2[each.key].root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

### Creates VPC link integration to ANY method in API Gateway
resource "aws_api_gateway_integration" "integration_v2" {
  depends_on = [
    aws_api_gateway_method.vpc_link_method_v2
  ]
  for_each = var.api_gateways_in

  rest_api_id = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  resource_id = aws_api_gateway_rest_api.rest_api_v2[each.key].root_resource_id

  http_method             = "ANY"
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = each.value.internal_url #"http://segment-tracker-prd.kumuapi.com"

  connection_type = "VPC_LINK"
  connection_id   = var.vpc_link_id_in ###edit this
}

### Deploys changes of the API Gateway REST API to default stage
resource "aws_api_gateway_deployment" "deployment_v2" {
  rest_api_id = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  for_each    = var.api_gateways_in
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.vpc_link_method_v2[each.key],
      aws_api_gateway_integration.integration_v2[each.key],
      #      aws_api_gateway_method.api_proxy_method_v2[each.key],
      #      aws_api_gateway_integration.proxy_integration_v2[each.key]
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# # Creates stage 
resource "aws_api_gateway_stage" "stage_v2" {
  for_each      = var.api_gateways_in
  deployment_id = aws_api_gateway_deployment.deployment_v2[each.key].id
  rest_api_id   = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  stage_name    = each.value.stage_name
}

resource "aws_api_gateway_domain_name" "custom_domain_name_v2" {
  for_each                 = var.api_gateways_in
  domain_name              = each.value.external_url
  regional_certificate_arn = var.regional_certificate_arn_in
  security_policy          = "TLS_1_2"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "custom_domain_name_map_v2" {
  for_each    = var.api_gateways_in
  depends_on  = [aws_api_gateway_domain_name.custom_domain_name_v2]
  api_id      = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  stage_name  = aws_api_gateway_stage.stage_v2[each.key].stage_name
  domain_name = aws_api_gateway_domain_name.custom_domain_name_v2[each.key].domain_name
}


# ###PROXY SECTION######
resource "aws_api_gateway_resource" "proxy_resource_v2" {
  for_each    = var.api_gateways_in
  rest_api_id = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  parent_id   = aws_api_gateway_rest_api.rest_api_v2[each.key].root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_integration" "proxy_integration_v2" {
  for_each                = var.api_gateways_in
  rest_api_id             = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  resource_id             = aws_api_gateway_resource.proxy_resource_v2[each.key].id
  http_method             = aws_api_gateway_method.vpc_link_method_v2[each.key].http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = join("/", [each.value.internal_url, "{proxy}"]) #"http://segment-tracker-prd.kumuapi.com/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"

  connection_type = "VPC_LINK"
  connection_id   = var.vpc_link_id_in
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_method" "api_proxy_method_v2" {
  for_each = var.api_gateways_in
  depends_on = [
    aws_api_gateway_rest_api.rest_api_v2,
    aws_api_gateway_resource.proxy_resource_v2
  ]

  rest_api_id        = aws_api_gateway_rest_api.rest_api_v2[each.key].id
  resource_id        = aws_api_gateway_resource.proxy_resource_v2[each.key].id
  http_method        = "ANY"
  authorization      = "NONE"
  request_parameters = { "method.request.path.proxy" = true }
}