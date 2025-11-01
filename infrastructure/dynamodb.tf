resource "aws_dynamodb_table" "stock_prices" {
  name         = "StockPrices"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "symbol"

  attribute {
    name = "symbol"
    type = "S"
  }
}
