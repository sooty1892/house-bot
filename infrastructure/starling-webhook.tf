module "sterling-webhook-lambda" {
  source = "./lambda_module/"
  function_name = "sterling-webhook"
}

resource "aws_dynamodb_table" "starling_webhook_notification_tracker" {
  name = "starling_webhook_notification_tracker",
  read_capacity = 1,
  write_capacity = 1,
  hash_key = "NotificationId"

  attribute {
    name = "NotificationId"
    type = "S"
  }
}