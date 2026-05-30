##########################################
# Random ID for unique bucket name
##########################################
resource "random_id" "bucket_id" {
  byte_length = 4
}

##########################################
# S3 Bucket (private, secure)
##########################################
resource "aws_s3_bucket" "stock_data_bucket" {
  bucket = "stock-market-data-${random_id.bucket_id.hex}"

  tags = {
    Name        = "StockDataBucket"
    Environment = "prod"
  }
}

##########################################
# Ownership control (no ACL conflicts)
##########################################
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.stock_data_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

##########################################
# Allow website hosting (private for now)
##########################################
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.stock_data_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

##########################################
# Keep public access blocked (for safety)
##########################################
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.stock_data_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
