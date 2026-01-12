variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "app_port" {
  type = number
  default = 8080
}