##########################################
# Fetch Stock Data Lambda Function
##########################################
resource "aws_lambda_function" "fetch_stock_data" {
  function_name = "fetch-stock-data"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  filename         = "${path.module}/../src/lambda_functions/fetch_stock_data/app.zip"
  source_code_hash = filebase64sha256("${path.module}/../src/lambda_functions/fetch_stock_data/app.zip")

  # ✅ Environment variables now managed by Terraform
  environment {
    variables = {
      SQS_QUEUE_URL     = aws_sqs_queue.stock_queue.url
      ALPHA_VANTAGE_KEY = var.alpha_vantage_key
      DYNAMODB_TABLE    = aws_dynamodb_table.stock_prices.name
    }
  }

  timeout = 15
}

##########################################
# Process Stock Data Lambda Function
##########################################
resource "aws_lambda_function" "process_stock_data" {
  function_name = "process-stock-data"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  filename         = "${path.module}/../src/lambda_functions/process_stock_data/app.zip"
  source_code_hash = filebase64sha256("${path.module}/../src/lambda_functions/process_stock_data/app.zip")

  environment {
    variables = {
      DYNAMO_TABLE  = aws_dynamodb_table.stock_prices.name
      SNS_TOPIC_ARN = aws_sns_topic.stock_alerts.arn
    }
  }

  timeout = 15
}

##########################################
# Get Stock Data Lambda (For API Gateway)
##########################################
resource "aws_lambda_function" "get_stock_data" {
  function_name = "get-stock-data"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  filename         = "${path.module}/../src/lambda_functions/get_stock_data/app.zip"
  source_code_hash = filebase64sha256("${path.module}/../src/lambda_functions/get_stock_data/app.zip")

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.stock_prices.name
    }
  }

  timeout = 15
}
