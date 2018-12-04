output "lambda_arn" {
  value       = "${aws_lambda_function.house_bot_lambda.arn}"
}

output "lambda_invoke_arn" {
  value       = "${aws_lambda_function.house_bot_lambda.invoke_arn}"
}