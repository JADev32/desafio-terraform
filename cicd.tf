
# 8) Container Registry (ECR)
module "ecr" {
  source = "./modules/ecr"

  name = local.name_prefix
  tags = local.common_tags
}


# 14) Pipeline CI/CD
module "pipeline" {
  source = "./modules/pipeline"

  name_prefix         = local.name_prefix
  aws_region          = var.aws_region
  aws_account_id      = data.aws_caller_identity.current.account_id
  codeconnection_arn  = var.codeconnection_arn
  github_full_repo_id = var.github_full_repo_id
  branch              = var.github_branch

  codebuild_role_arn    = module.iam.codebuild_role_arn
  codepipeline_role_arn = module.iam.codepipeline_role_arn

  ecr_repository_name = module.ecr.frontend_repository_name
  image_tag           = var.frontend_image_tag

  ecs_cluster_name = module.ecs_cluster.cluster_name
  ecs_service_name = module.ecs_service_frontend.service_name

  tags = local.common_tags
}

module "sns_notifications" {
  source = "./modules/sns"

  name_prefix         = local.name_prefix
  pipeline_name       = module.pipeline.pipeline_name
  email_subscriptions = var.notification_emails

  tags = local.common_tags
}
