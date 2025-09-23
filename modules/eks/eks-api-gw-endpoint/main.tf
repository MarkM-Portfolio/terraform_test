resource "aws_api_gateway_resource" "api" {
  rest_api_id = var.rest_api_id
  parent_id   = var.api_parent_id
  path_part   = var.api_path
}

resource "aws_api_gateway_method" "method" {
  depends_on         = [aws_api_gateway_resource.api]
  rest_api_id        = var.rest_api_id
  resource_id        = aws_api_gateway_resource.api.id
  http_method        = var.api_method
  authorization      = "NONE"
  request_parameters = { "method.request.path.proxy" = true }
}

resource "aws_api_gateway_integration" "integration" {
  depends_on = [
    aws_api_gateway_resource.api,
    aws_api_gateway_method.method
  ]
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.api.id
  http_method             = var.api_method
  type                    = var.integration_type
  integration_http_method = var.api_method
  uri                     = "${var.api_proxy_uri}/${var.api_path}"
  passthrough_behavior    = "WHEN_NO_MATCH"
  connection_type         = var.connection_type
  connection_id           = var.api_connection_id
}


### PROXY endpoint

resource "aws_api_gateway_resource" "proxy_resource" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.api.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_proxy_method" {
  depends_on         = [aws_api_gateway_resource.proxy_resource]
  rest_api_id        = var.rest_api_id
  resource_id        = aws_api_gateway_resource.proxy_resource.id
  http_method        = var.api_method
  authorization      = "NONE"
  request_parameters = { "method.request.path.proxy" = true }
}
resource "aws_api_gateway_integration" "proxy_integration" {
  depends_on = [
    aws_api_gateway_resource.proxy_resource,
    aws_api_gateway_method.api_proxy_method
  ]
  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.proxy_resource.id
  http_method             = var.api_method
  type                    = var.integration_type
  integration_http_method = var.api_method
  uri                     = "${var.api_proxy_uri}/${var.api_path}/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"

  connection_type = var.connection_type
  connection_id   = var.api_connection_id
  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = var.rest_api_id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.method,
      aws_api_gateway_integration.integration,
      aws_api_gateway_method.api_proxy_method,
      aws_api_gateway_integration.proxy_integration
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
