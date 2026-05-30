resource "aws_lambda_event_source_mapping" "sqs_to_processor" {
  event_source_arn = aws_sqs_queue.stock_queue.arn
  function_name    = aws_lambda_function.process_stock_data.arn
  batch_size       = 1
}
