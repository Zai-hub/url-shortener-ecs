variable "aws_region" {
  type        = string
  default     = ""
}

variable "aws_profile" {
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  type = string
}

variable "az_count" {
  type = number
}

variable "app_port" {
  type = number
  default = 8080
}

variable "project_name" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "state_bucket" {
  type = string
}

variable "lock_table" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "public_subnet" {
  type = string
}

