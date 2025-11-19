output "mysql_service_name" {
  value = aws_ecs_service.mysql_service.name
}

output "mysql_task_definition_arn" {
  value = aws_ecs_task_definition.mysql_task.arn
}
