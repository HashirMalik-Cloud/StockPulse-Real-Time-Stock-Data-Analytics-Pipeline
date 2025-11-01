output "sns_topic_arn" {
  value = aws_sns_topic.stock_alerts.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.stock_queue.url
}

output "dynamodb_table" {
  value = aws_dynamodb_table.stock_prices.name
}
