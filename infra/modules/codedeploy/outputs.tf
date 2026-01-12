output "app_name" {
  value = aws_codedeploy_app.main
}

output "deployment_group_name" {
  value = aws_codedeploy_deployment_group.main.deployment_group_name
}

output "app_id" {
  value = aws_codedeploy_app.main.id
}