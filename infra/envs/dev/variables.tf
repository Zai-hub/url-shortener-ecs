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
  default = ""
}

variable "az_count" {
  type = number
  default = "2"
}

variable "app_port" {
  type = number
  default = 8080
}

variable "project_name" {
  type = string
  default = ""
}

variable "github_repo" {
  type = string
  default = ""
}

variable "state_bucket" {
  type = string
  default = ""
}

variable "lock_table" {
  type = string
  default = ""
}

variable "repository_name" {
  type = string
  default = ""
}

variable "domain_name" {
  type = string
  default = ""
}

variable "subdomain" {
  type = string
  default = ""
}

variable "public_subnet" {
  type = string
  default = ""
}

