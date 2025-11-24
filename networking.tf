# 1) Red
module "network" {
  source = "./modules/network"

  name                 = local.name_prefix
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.16.0/24"]
  private_subnet_cidrs = ["10.0.128.0/24", "10.0.144.0/24"]

  tags = local.common_tags
}

# 2) Security Groups
module "security" {
  source = "./modules/security"

  name                  = local.name_prefix
  vpc_id                = module.network.vpc_id
  vpc_dns_resolver_cidr = "10.0.0.2/32"
  tags                  = local.common_tags
}