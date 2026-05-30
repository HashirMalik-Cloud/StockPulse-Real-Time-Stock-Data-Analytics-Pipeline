resource "aws_cloudwatch_event_rule" "fetch_schedule" {
  name                = "fetch-stock-data-schedule"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "fetch_target" {
  rule      = aws_cloudwatch_event_rule.fetch_schedule.name
  target_id = "fetchLambda"
  arn       = aws_lambda_function.fetch_stock_data.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fetch_stock_data.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.fetch_schedule.arn
}
