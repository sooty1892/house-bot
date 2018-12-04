module "upcoming_payments_schedule_lambda" {
  source = "./lambda_module/"
  function_name = "upcoming_payments_schedule"
}

module "upcoming_payments_schedule_trigger" {
  source = "./cloudwatch_lambda_trigger_module/"
  lambda_arn = "${module.upcoming_payments_schedule_lambda.lambda_arn}"
  trigger_name = "upcoming_payments_schedule_trigger"
  schedule = "cron(0 12 * * ? *)"
}