module "telegram-webhook-lambda" {
  source = "./lambda_module/"
  function_name = "telegram-webhook"
}