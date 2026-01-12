output "vpc_id" {
  value = module.networking.vpc_id
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  value = module.dynamodb.table_arn
}

output "ecr_repository" {
  value = module.ecr.repository_url
}

output "route53_zone_id" {
  value = module.route53.zone_id
}

output "route53_name_servers" {
  value = module.route53.name_servers
}

output "certificate_arn" {
  value = module.acm.certificate_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_url" {
  value = "https//${module.alb.alb_dns_name}"
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "github_actions_role_arn" {
  value       = module.iam.github_role_arn
}