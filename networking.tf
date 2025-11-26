# 1) Red
module "network" {
  source = "./modules/network"

  name                 = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  azs                  = var.availability_zones
  public_subnet_cidrs  = local.calculated_public_subnets
  private_subnet_cidrs = local.calculated_private_subnets

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