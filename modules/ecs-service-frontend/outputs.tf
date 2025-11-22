output "frontend_service_name" {
  value = aws_ecs_service.frontend_service.name
}

output "frontend_task_definition_arn" {
  value = aws_ecs_task_definition.frontend_task.arn
}

output "service_name" {
  description = "Nombre del servicio ECS"
  value = aws_ecs_service.frontend_service.name
}
