variable "aws_region" {
  type        = string
}

variable "aws_profile" {
  type    = string
  default = ""
}

variable "dynamo_table_name" {
  type = string
}

variable "s3_bucket_name" { 
  type = string
}
