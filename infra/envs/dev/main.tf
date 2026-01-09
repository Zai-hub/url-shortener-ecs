module "networking" {
  source = "../../modules/networking"

  az_count = var.az_count
  vpc_cidr = var.vpc_cidr

}