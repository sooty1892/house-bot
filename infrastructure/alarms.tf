resource "aws_sns_topic" "alarm" {
  name = "house-bot-alarms"

  provisioner "local-exec" {
    command = "aws sns subscribe --region ${var.region} --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarm_email}"
  }
}

resource "aws_cloudwatch_metric_alarm" "errors" {
  alarm_name                = "lambda-errors-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  threshold                 = "1"
  evaluation_periods        = "1"
  datapoints_to_alarm       = "1"
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = "60"
  statistic                 = "Sum"
  treat_missing_data        = "notBreaching"
  alarm_description         = "Monitors errors from house bot lambdas"
  alarm_actions             = ["${aws_sns_topic.alarm.arn}"]
}