resource "aws_lambda_function" "house_bot_lambda" {
  filename         = "../${var.filename}"
  function_name    = "${var.function_name}"
  role             = "${var.lambda_role}"
  handler          = "${var.function_name}.run"
  source_code_hash = "${base64sha256(file("../${var.filename}"))}"
  runtime          = "nodejs8.10"
  memory_size      = 128
  reserved_concurrent_executions = 1
}