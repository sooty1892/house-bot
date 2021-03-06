variable rest_api_id {}
variable parent_id {}
variable path {}
variable region {}
variable environment {}
variable lambda_invoke_arn {}
variable lambda_arn {}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = "${var.rest_api_id}"
  parent_id = "${var.parent_id}"
  path_part = "${var.path}"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.api_resource.id}"
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_method_integration" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.api_resource.id}"
  http_method = "${aws_api_gateway_method.api_method.http_method}"
  type = "AWS_PROXY"
  uri = "${var.lambda_invoke_arn}"
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    "aws_api_gateway_method.api_method",
    "aws_api_gateway_integration.api_method_integration"
  ]
  rest_api_id = "${var.rest_api_id}"
  stage_name = "${var.environment}"
}

resource "aws_lambda_permission" "apigw_to_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_deployment.deployment.execution_arn}/*/*"
}