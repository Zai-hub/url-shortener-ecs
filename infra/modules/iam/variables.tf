variable "project_name" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
  default     = null
  nullable    = true
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

variable "region" {
  type = string
}
