output "ecs_instance_role_arn" {
  value = aws_iam_role.ecs_instance_role.arn
}

######output "ecs_instance_profile_name" {
 ###### value = aws_iam_instance_profile.ecs_instance_profile.name
######}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_mysql_role_arn" {
  value = aws_iam_role.ecs_task_mysql_role.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "ecs_instance_profile_arn" {
  value = aws_iam_instance_profile.ecs_instance_profile.arn
  description = "ARN del instance profile usado por las instancias ECS"
}
