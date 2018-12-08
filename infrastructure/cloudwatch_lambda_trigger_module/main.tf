resource "aws_cloudwatch_event_rule" "trigger" {
  name = "${var.trigger_name}"
  schedule_expression = "${var.schedule}"
  is_enabled = "${var.is_enabled}"
}

resource "aws_cloudwatch_event_target" "trigger_target" {
  rule = "${aws_cloudwatch_event_rule.trigger.name}"
  arn = "${var.lambda_arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${var.lambda_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.trigger.arn}"
}