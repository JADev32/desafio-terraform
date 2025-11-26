output "topic_arn" {
  value       = aws_sns_topic.pipeline_notifications.arn
  description = "ARN del tópico SNS de notificaciones"
}

output "event_rule_name" {
  value       = aws_cloudwatch_event_rule.pipeline_state_change.name
  description = "Nombre de la regla de EventBridge"
}
