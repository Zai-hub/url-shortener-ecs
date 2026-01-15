
variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ecs_security_group_id" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "image_tag" {
  type = string
  default = "latest"
}

variable "container_port" {
  type = number
  default = 8080
}

variable "task_cpu" {
  type = string
  default = "256"
}

variable "task_memory" {
  type = string
  default = "512"
}

variable "desired_count" {
  type = number
  default = 2
}

variable "dynamodb_table_name" {
  type = string
}

variable "blue_target_group_arn" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

variable "aws_region" {
  type = string
}