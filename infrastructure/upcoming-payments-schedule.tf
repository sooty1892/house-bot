module "upcoming_payments_schedule-lambda" {
  source = "./lambda_module/"
  function_name = "upcoming_payments_schedule"
}