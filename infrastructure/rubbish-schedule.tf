module "rubbish_schedule_lambda" {
  source = "./lambda_module/"
  function_name = "rubbish_schedule"
}

module "rubbish_schedule_trigger" {
  source = "./cloudwatch_lambda_trigger_module/"
  lambda_arn = "${module.rubbish_schedule_lambda.lambda_arn}"
  trigger_name = "rubbish_schedule_trigger"
  schedule = "cron(0 22 ? * TUE *)"
}