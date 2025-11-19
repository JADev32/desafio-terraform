output "target_group_arn" {
  description = "El ARN del Target Group creado."
  value       = aws_lb_target_group.app_tg.arn
}