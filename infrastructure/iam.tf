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

resource "aws_iam_role" "lamda_cloudwatch_role" {
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

resource "aws_iam_role" "lamda_cloudwatch_dynamodb_role" {
  name = "lambda_cloudwatch_dynamodb_global"

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
  role = "${aws_iam_role.lamda_cloudwatch_role.id}"

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

resource "aws_iam_policy" "lambda_to_dynamodb" {
  name        = "lambda_to_dynamodb"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_to_dynamodb_attachment" {
  role = "${aws_iam_role.lamda_cloudwatch_dynamodb_role.name}"
  policy_arn = "${aws_iam_policy.lambda_to_dynamodb.arn}"
}


resource "aws_iam_role_policy_attachment" "api_push_to_cloudwatch_attachment" {
  role = "${aws_iam_role.cloudwatch.name}"
  policy_arn = "${data.aws_iam_policy.api_push_to_cloudwatch.arn}"
}

data "aws_iam_policy" "api_push_to_cloudwatch" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}