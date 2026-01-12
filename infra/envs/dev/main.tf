module "networking" {
  source = "../../modules/networking"
  az_count = var.az_count
  vpc_cidr = var.vpc_cidr
  aws_region = var.aws_region
  vpc_endpoints_sg_id = module.security.vpc_endpoints_sg_id
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.networking.vpc_id
  vpc_cidr = var.vpc_cidr
  app_port = var.app_port
}

module  "iam" {
  source = "../../modules/iam"
  project_name        = var.project_name
  region              = var.aws_region
  github_repo         = var.github_repo
  state_bucket        = var.state_bucket
  lock_table          = var.lock_table
  dynamodb_table_arn  = module.dynamodb.table_arn
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  project_name = var.project_name
}

module "ecr" {
  source = "../../modules/ecr"
  project_name = var.project_name
  repository_name = var.repository_name
}

module "route53" {
  source = "../../modules/route53"
  project_name = var.project_name
  domain_name = var.domain_name
  subdomain = var.subdomain
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "acm" {
  source = "../../modules/acm"
  project_name = var.domain_name
  domain_name = var.domain_name
  subdomain = var.subdomain
  zone_id = module.route53.zone_id
}

module "alb" {
  source = "../../modules/alb"
  project_name           = var.project_name
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  alb_security_group = module.security.alb_sg_id
  container_port         = 8080
  acm_certificate_arn    = module.acm.certificate_arn
}

module "ecs" {
  source = "../../modules/ecs"
  project_name           = var.project_name
  vpc_id                 = module.networking.vpc_id
  private_subnet_ids     = module.networking.private_subnet_ids
  ecs_security_group_id  = module.security.ecs_sg_id
  ecs_task_role_arn      = module.iam.ecs_task_role_arn
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecr_repository_url     = module.ecr.repository_url
  image_tag              = "latest"
  dynamodb_table_name    = module.dynamodb.table_name
  blue_target_group_arn  = module.alb.blue_target_group_arn
  alb_listener_arn       = module.alb.https_listener_arn
  aws_region             = var.aws_region
}


module "waf" {
  source = "../../modules/waf"
  project_name = var.project_name
  alb_arn = module.alb.alb_arn
}

module "codedeploy" {
  source = "../../modules/codedeploy"
  project_name = var.project_name
  codedeploy_role_arn = module.iam.codedeploy_role_arn
  ecs_service_name = module.ecs.service_name
  ecs_cluster_name = module.ecs.cluster_name
  alb_listener_arn = module.alb.https_listener_arn
  blue_target_group_name = module.alb.blue_target_group_name
  green_target_group_name = module.alb.green_target_group_name
}