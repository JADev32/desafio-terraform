output "vpc_id" {
  value       = module.network.vpc_id
  description = "ID de la VPC creada."
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "Subnets públicas."
}

output "private_subnet_ids" {
  value       = module.network.private_subnet_ids
  description = "Subnets privadas."
}

output "security_group_ids" {
  description = "Security Groups principales."
  value = {
    alb       = module.security.sg_alb_id
    frontend  = module.security.sg_frontend_id
    db        = module.security.sg_db_id
    efs       = module.security.sg_efs_id
    ecs_hosts = module.security.sg_ecs_hosts_id
  }
}

output "efs_id" {
  description = "ID del file system EFS."
  value       = module.efs.file_system_id
}

output "efs_access_point_id" {
  description = "IDs del Access Point."
  value       = module.efs.access_point_id
}

# output "ssm_db_parameters_arn" {
#   description = "ARNs de parámetros SSM de DB (para ECS/pipeline)."
#   value       = module.ssm.db_parameters_arn
# }

# output "ssm_db_parameters_name" {
#   description = "Nombres de parámetros SSM de DB."
#   value       = module.ssm.db_parameters_name
# }

output "iam_roles_arn" {
  description = "ARNs de roles IAM."
  value = {
    ecs_instance_role       = module.iam.ecs_instance_role_arn
    ecs_task_execution_role = module.iam.ecs_task_execution_role_arn
    codebuild_role          = module.iam.codebuild_role_arn
    codepipeline_role       = module.iam.codepipeline_role_arn
  }
}

output "alb_dns_name" {
  description = "DNS Name bruto del ALB (sin Route 53)."
  value       = module.application_load_balancer.alb_dns_name
}

output "target_group_arn" {
  description = "ARN del Target Group del frontend."
  value       = module.target_group.target_group_arn
}

output "ecr_repository_urls" {
  description = "URLs de los repos ECR"
  value = {
    frontend = module.ecr.frontend_repository_url
    mysql    = module.ecr.mysql_repository_url
  }
}

output "app_public_fqdn" {
  description = "Nombre público del sitio lab3."
  value       = module.route53_record.record_fqdn
}

output "app_public_url" {
  description = "URL pública HTTPS del sitio."
  value       = "https://${module.route53_record.record_fqdn}"
}
