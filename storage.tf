# 4) Storage (EFS)
module "efs" {
  source = "./modules/efs"

  environment = var.environment
  name        = local.name_prefix

  private_subnet_ids    = module.network.private_subnet_ids
  efs_security_group_id = module.security.sg_efs_id

  tags = local.common_tags
}

