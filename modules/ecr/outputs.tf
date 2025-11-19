output "frontend_repository_url" {
  description = "URL del repositorio ECR del frontend"
  value       = aws_ecr_repository.frontend.repository_url
}

output "frontend_repository_arn" {
  description = "ARN del repositorio ECR del frontend"
  value       = aws_ecr_repository.frontend.arn
}

output "mysql_repository_url" {
  description = "URL del repositorio ECR de MySQL"
  value       = aws_ecr_repository.mysql.repository_url
}

output "mysql_repository_arn" {
  description = "ARN del repositorio ECR de MySQL"
  value       = aws_ecr_repository.mysql.arn
}
