provider "aws" {
  region = "${var.region}"
}

resource "aws_api_gateway_rest_api" "house_bot_api" {
  name = "house_bot_api"
  description = "API to support all rest based integrations to the House Bot lambdas"
}