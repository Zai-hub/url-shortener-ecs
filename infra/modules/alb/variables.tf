variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group" {
  type = string
}

variable "container_port" {
  type = number
  default = 8080
}

variable "acm_certificate_arn" {
  type = string
}
