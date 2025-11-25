module "iam" {
  source = "./modules/iam"

  providers = {
    aws = aws.iam
  }

  prefix     = local.name_prefix
  aws_region = var.aws_region
  efs_id = module.efs.file_system_id
}
