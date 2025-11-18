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