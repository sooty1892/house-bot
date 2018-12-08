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

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lamda_role" {
  name = "lambda_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_write_to_cloudwatch_policy" {
  name = "lambda_write_to_cloudwatch"
  role = "${aws_iam_role.lamda_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sto-readonly-role-policy-attach" {
  role = "${aws_iam_role.cloudwatch.name}"
  policy_arn = "${data.aws_iam_policy.ReadOnlyAccess.arn}"
}

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}