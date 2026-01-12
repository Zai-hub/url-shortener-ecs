output "table_name" {
  value = aws_dynamodb_table.url_mappings.name
}

output "table_arn" {
  value = aws_dynamodb_table.url_mappings.arn
}