# 4) Storage (EFS)
module "efs" {
  source = "./modules/efs"

  environment = var.environment
  name        = local.name_prefix

  private_subnet_ids    = module.network.private_subnet_ids
  efs_security_group_id = module.security.sg_efs_id

  tags = local.common_tags
}

# 7) Parámetros de la base de datos en SSM
module "ssm" {
  source = "./modules/ssm"

  name = local.name_prefix

  # prefijo por ambiente → /lab3/dev/db/... o /lab3/prod/db/...
  db_parameter_path_prefix = "/lab3/${var.environment}/db"

  db_host = var.db_host
  db_name = var.db_name
  db_user = var.db_user
  db_pass = var.db_pass

  tags = local.common_tags
}