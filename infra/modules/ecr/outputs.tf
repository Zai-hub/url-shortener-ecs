output "repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "repository_arm" {
  value = aws_ecr_repository.app.arn
}