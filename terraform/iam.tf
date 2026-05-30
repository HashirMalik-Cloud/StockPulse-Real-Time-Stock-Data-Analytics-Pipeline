# IAM role that Lambda functions will assume
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS basic Lambda execution permissions (for CloudWatch logs)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom inline policy for Lambda to access SQS, DynamoDB, and SNS
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_extended_permissions"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ✅ Allow Lambda to read/write CloudWatch logs
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },

      # ✅ Allow Lambda to receive and delete messages from SQS
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:SendMessage"
        ],
        Effect = "Allow",
        Resource = aws_sqs_queue.stock_queue.arn
      },

      # ✅ Allow Lambda to read/write data in DynamoDB table
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan"          # <-- Added Scan permission
        ],
        Effect = "Allow",
        Resource = aws_dynamodb_table.stock_prices.arn
      },

      # ✅ Allow Lambda to publish alerts to SNS topic
      {
        Action = [
          "sns:Publish"
        ],
        Effect = "Allow",
        Resource = aws_sns_topic.stock_alerts.arn
      }
    ]
  })
}
