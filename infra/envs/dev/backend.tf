terraform {
  required_version = ">= 1.6.0"
  
  backend "s3" {
    bucket = "url-shortener-tf-state"
    dynamodb_table = "url-shortener-tf-lock"
    key = "main/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
  }
}
