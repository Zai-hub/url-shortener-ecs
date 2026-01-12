resource "aws_dynamodb_table" "url_mappings" {
  name             = "${var.project_name}-url-mappings"
  hash_key         = "id"
  billing_mode     = "PAY_PER_REQUEST"


  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-url-mappings"
  }
}