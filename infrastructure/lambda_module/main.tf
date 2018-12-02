resource "aws_lambda_function" "house_bot_lambda" {
  filename         = "../${var.filename}"
  function_name    = "${var.function_name}"
  role             = "arn:aws:iam::391746183168:role/house-bot-dev-eu-west-2-lambdaRole"
  handler          = "${var.function_name}.run"
  source_code_hash = "${base64sha256(file("../${var.filename}"))}"
  runtime          = "nodejs8.10"
  memory_size      = 128
  reserved_concurrent_executions = 1
}