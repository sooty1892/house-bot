module "error_schedule_lambda" {
  source = "./lambda_module/"
  function_name = "error-schedule"
  lambda_role = "${aws_iam_role.lamda_cloudwatch_role.arn}"
}

module "error_schedule_trigger" {
  source = "./cloudwatch_lambda_trigger_module/"
  lambda_arn = "${module.error_schedule_lambda.lambda_arn}"
  trigger_name = "error_schedule_trigger"
  schedule = "cron(0/1 * * * ? *)"
  lambda_name = "error-schedule"
  is_enabled = "false"
}