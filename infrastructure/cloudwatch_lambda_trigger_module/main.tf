resource "aws_cloudwatch_event_rule" "trigger" {
  name = "${var.trigger_name}"
  schedule_expression = "${var.schedule}"
}

resource "aws_cloudwatch_event_target" "trigger_target" {
  rule = "${aws_cloudwatch_event_rule.trigger.name}"
  arn = "${var.lambda_arn}"
}