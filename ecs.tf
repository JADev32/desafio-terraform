# ecs.tf

# 10) ECS Cluster (EC2)
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  name         = local.name_prefix
  cluster_name = "${local.name_prefix}-cluster"

  # AMI recomendada para ECS
  ami_id        = local.ecs_ami_id
  instance_type = "t2.micro"

  ecs_instance_profile_arn = module.iam.ecs_instance_profile_arn

  private_subnets = module.network.private_subnet_ids
  sg_ecs_hosts_id = module.security.sg_ecs_hosts_id

  tags = local.common_tags
}

# 12) Service Discovery (Cloud Map)
module "service_discovery" {
  source = "./modules/service-discovery"
  vpc_id = module.network.vpc_id
}

# 11) ECS Service - Frontend
module "ecs_service_frontend" {
  source = "./modules/ecs-service-frontend"

  name                   = local.name_prefix
  cluster_name           = module.ecs_cluster.cluster_name
  capacity_provider_name = module.ecs_cluster.capacity_provider_name

  private_subnets = module.network.private_subnet_ids
  sg_frontend_id  = module.security.sg_frontend_id

  target_group_arn = module.target_group.target_group_arn

  ecr_repo_url = module.ecr.frontend_repository_url
  image_tag    = var.frontend_image_tag

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn

  db_host_arn = data.aws_ssm_parameter.db_host.arn
  db_name_arn = data.aws_ssm_parameter.db_name.arn
  db_user_arn = data.aws_ssm_parameter.db_user.arn
  db_pass_arn = data.aws_ssm_parameter.db_pass.arn

  aws_region = var.aws_region
  tags       = local.common_tags
}

# 13) ECS Service - MySQL
module "ecs_service_mysql" {
  source                 = "./modules/ecs-service-mysql"
  name                   = local.name_prefix
  cluster_name           = module.ecs_cluster.cluster_name
  capacity_provider_name = module.ecs_cluster.capacity_provider_name

  private_subnets = module.network.private_subnet_ids
  sg_db_id        = module.security.sg_db_id
  efs_id          = module.efs.file_system_id
  efs_access_point_id = module.efs.access_point_id

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn

  mysql_image          = module.ecr.mysql_repository_url
  service_registry_arn = module.service_discovery.mysql_service_arn
  
  # Variables de configuración MySQL
  mysql_database       = data.aws_ssm_parameter.db_name.arn
  mysql_root_password  = data.aws_ssm_parameter.db_pass.arn

  aws_region = var.aws_region
  tags       = local.common_tags
}
