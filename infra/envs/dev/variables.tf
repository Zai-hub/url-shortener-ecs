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