variable "region" {
    default = "eu-west-2"
}

variable "environment" {
    default = "dev"
}

variable "alarm_email" {}

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "house-bot"
    key    = "terraform"
    region = "eu-west-2"
  }
}

resource "aws_api_gateway_rest_api" "house_bot_api" {
  name = "house_bot_api"
  description = "API to support all rest based integrations to the House Bot lambdas"
}

resource "aws_api_gateway_method_settings" "api_settings" {
  rest_api_id = "${aws_api_gateway_rest_api.house_bot_api.id}"
  stage_name  = "${var.environment}"
  method_path = "*/*"
  settings {
    logging_level = "INFO"
    metrics_enabled = true
  }
}
resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = "${aws_iam_role.cloudwatch.arn}"
}