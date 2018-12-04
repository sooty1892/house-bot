module "starling_webhook_lambda" {
  source = "./lambda_module/"
  function_name = "sterling-webhook"
}

resource "aws_dynamodb_table" "starling_webhook_notification_tracker" {
  name = "starling_webhook_notification_tracker",
  read_capacity = 1,
  write_capacity = 1,
  hash_key = "NotificationId"

  attribute {
    name = "NotificationId"
    type = "S"
  }
}

module "starling_api_gateway_resource" {
  source = "./api_gateway_resource_module/"
  path = "starling"
  parent_id = "${aws_api_gateway_rest_api.house_bot_api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.house_bot_api.id}"
  region = "${var.region}"
  environment = "${var.environment}"
  lambda_invoke_arn = "${module.starling_webhook_lambda.lambda_invoke_arn}"
  lambda_arn = "${module.starling_webhook_lambda.lambda_arn}"
}