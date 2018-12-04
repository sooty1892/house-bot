module "telegram_webhook_lambda" {
  source = "./lambda_module/"
  function_name = "telegram-webhook"
}

module "telegram_api_gateway_resource" {
  source = "./api_gateway_resource_module/"
  path = "telegram"
  parent_id = "${aws_api_gateway_rest_api.house_bot_api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.house_bot_api.id}"
  region = "${var.region}"
  environment = "${var.environment}"
  lambda_invoke_arn = "${module.telegram_webhook_lambda.lambda_invoke_arn}"
  lambda_arn = "${module.telegram_webhook_lambda.lambda_arn}"
}