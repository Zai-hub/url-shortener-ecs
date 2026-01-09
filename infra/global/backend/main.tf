# DynamoDB 
resource "aws_dynamodb_table" "tf_lock" {
  name         = var.dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


# S3
# create state-files S3 bucket 
resource "aws_s3_bucket" "tf_state" {  
  bucket = var.s3_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

# enable S3 bucket versioning 
resource "aws_s3_bucket_versioning" "tf_state" { 
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


# enable S3 bucket encryption
resource "aws_kms_key" "tf_state" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tf_state.arn
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}


# block S3 bucket public access
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}