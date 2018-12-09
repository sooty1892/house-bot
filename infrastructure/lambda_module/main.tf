variable filename {
    default = "artifact.zip"
}
variable function_name {}

variable lambda_role {}

output "lambda_arn" {
  value       = "${aws_lambda_function.house_bot_lambda.arn}"
}

output "lambda_invoke_arn" {
  value       = "${aws_lambda_function.house_bot_lambda.invoke_arn}"
}

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