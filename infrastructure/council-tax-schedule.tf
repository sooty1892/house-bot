module "council_tax_schedule_lambda" {
  source = "./lambda_module/"
  function_name = "council_tax_schedule"
  lambda_role = "${aws_iam_role.lambda_cloudwatch_role.arn}"
}

module "council_tax_schedule_trigger" {
  source = "./cloudwatch_lambda_trigger_module/"
  lambda_arn = "${module.council_tax_schedule_lambda.lambda_arn}"
  trigger_name = "council_tax_schedule_trigger"
  schedule = "cron(0 20 28 * ? *)"
  lambda_name = "council_tax_schedule"
}