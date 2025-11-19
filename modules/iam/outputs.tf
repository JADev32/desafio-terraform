output "ecs_instance_role_arn" {
  value = aws_iam_role.ecs_instance_role.arn
}

output "ecs_instance_profile_name" {
  value = local.ecs_instance_profile_name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "ecs_instance_profile_arn" {
  value       = local.ecs_instance_profile_arn
  description = "ARN del instance profile usado por las instancias ECS"
}
