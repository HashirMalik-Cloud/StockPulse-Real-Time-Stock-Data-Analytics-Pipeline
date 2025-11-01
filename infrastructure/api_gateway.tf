##########################################
# API Gateway (REST) for Stock Data
##########################################

resource "aws_api_gateway_rest_api" "stock_api" {
  name        = "StockDataAPI"
  description = "REST API for fetching stock data from DynamoDB via Lambda"
}

##########################################
# /stocks resource
##########################################

resource "aws_api_gateway_resource" "stocks_resource" {
  rest_api_id = aws_api_gateway_rest_api.stock_api.id
  parent_id   = aws_api_gateway_rest_api.stock_api.root_resource_id
  path_part   = "stocks"
}

##########################################
# GET Method (Fetch Stock Data)
##########################################

resource "aws_api_gateway_method" "get_stocks_method" {
  rest_api_id   = aws_api_gateway_rest_api.stock_api.id
  resource_id   = aws_api_gateway_resource.stocks_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_stocks_integration" {
  rest_api_id             = aws_api_gateway_rest_api.stock_api.id
  resource_id             = aws_api_gateway_resource.stocks_resource.id
  http_method             = aws_api_gateway_method.get_stocks_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_stock_data.invoke_arn
}

##########################################
# OPTIONS Method for CORS
##########################################

resource "aws_api_gateway_method" "options_stocks" {
  rest_api_id   = aws_api_gateway_rest_api.stock_api.id
  resource_id   = aws_api_gateway_resource.stocks_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.stock_api.id
  resource_id             = aws_api_gateway_resource.stocks_resource.id
  http_method             = aws_api_gateway_method.options_stocks.http_method
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.stock_api.id
  resource_id = aws_api_gateway_resource.stocks_resource.id
  http_method = aws_api_gateway_method.options_stocks.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.stock_api.id
  resource_id = aws_api_gateway_resource.stocks_resource.id
  http_method = aws_api_gateway_method.options_stocks.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }
}

##########################################
# Deployment + Stage (Clean Redeploy)
##########################################

resource "aws_api_gateway_deployment" "stock_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.get_stocks_integration,
    aws_api_gateway_integration.options_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.stock_api.id
  description = "Deployment for Stock Data API"

  # Add a timestamp to force redeployment when config changes
  triggers = {
    redeploy_trigger = timestamp()
  }
}

resource "aws_api_gateway_stage" "prod_stage" {
  deployment_id = aws_api_gateway_deployment.stock_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.stock_api.id
  stage_name    = "prod"
  description   = "Production stage for Stock Data API"
}

##########################################
# Lambda Permission for API Gateway
##########################################

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_stock_data.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.stock_api.execution_arn}/*/*"
}
