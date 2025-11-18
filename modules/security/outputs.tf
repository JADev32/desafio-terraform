output "sg_alb_id" {
  description = "Security Group del ALB."
  value       = aws_security_group.alb.id
}

output "sg_frontend_id" {
  description = "Security Group del frontend."
  value       = aws_security_group.frontend.id
}

output "sg_db_id" {
  description = "Security Group de la base de datos (MySQL)."
  value       = aws_security_group.db.id
}

output "sg_efs_id" {
  description = "Security Group de EFS."
  value       = aws_security_group.efs.id
}

output "sg_ecs_hosts_id" {
  description = "Security Group de las instancias EC2 del cluster ECS."
  value       = aws_security_group.ecs_hosts.id
}
