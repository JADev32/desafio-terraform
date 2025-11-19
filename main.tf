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

# 2) Security Groups
module "security" {
  source = "./modules/security"

  name                  = "${var.project_name}-${var.environment}"
  vpc_id                = module.network.vpc_id
  vpc_dns_resolver_cidr = "10.0.0.2/32"
  tags                  = local.common_tags
}

# 3) Storage (EFS)
module "efs" {
  source = "./modules/efs"

  environment = var.environment
  name        = "${var.project_name}-${var.environment}"

  private_subnet_ids   = module.network.private_subnet_ids
  efs_security_group_id = module.security.sg_efs_id

  tags = local.common_tags
}

# 4) Parámetros de la base de datos en SSM
module "ssm" {
  source = "./modules/ssm"

  name = "${var.project_name}-${var.environment}"

  # Mejora: prefijo por ambiente → /lab3/dev/db/... o /lab3/prod/db/...
  db_parameter_path_prefix = "/lab3/${var.environment}/db"

  db_host     = var.db_host
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password

  tags = local.common_tags
}
