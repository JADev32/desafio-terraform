locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "Grupo-Lab3"
  }
}

# 1) Red
module "network" {
  source = "./modules/network"

  name                 = "${var.project_name}-${var.environment}"
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.16.0/24"]
  private_subnet_cidrs = ["10.0.128.0/24", "10.0.144.0/24"]

  tags = local.common_tags
}
