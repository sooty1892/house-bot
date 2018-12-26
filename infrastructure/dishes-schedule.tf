module "dishes_schedule_lambda" {
  source = "./lambda_module/"
  function_name = "dishes-schedule"
  lambda_role = "${aws_iam_role.lamda_cloudwatch_role.arn}"
}

module "dishes_schedule_trigger" {
  source = "./cloudwatch_lambda_trigger_module/"
  lambda_arn = "${module.dishes_schedule_lambda.lambda_arn}"
  trigger_name = "dishes_schedule_trigger"
  schedule = "cron(0 19 * * ? *)"
  lambda_name = "dishes-schedule"
}