# 3) IAM (Nuevos roles)
module "iam" {
  source = "./modules/iam"

  prefix     = local.name_prefix
  aws_region = var.aws_region
}
