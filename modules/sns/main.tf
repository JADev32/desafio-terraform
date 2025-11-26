resource "aws_sns_topic" "pipeline_notifications" {
  name         = "${var.name_prefix}-pipeline-notifications"
  display_name = "${var.name_prefix} pipeline notifications"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-pipeline-notifications"
  })
}

# Suscripciones por mail
resource "aws_sns_topic_subscription" "emails" {
  for_each = toset(var.email_subscriptions)

  topic_arn = aws_sns_topic.pipeline_notifications.arn
  protocol  = "email"
  endpoint  = each.value
}

# Regla de EventBridge para cambios de estado del pipeline
resource "aws_cloudwatch_event_rule" "pipeline_state_change" {
  name        = "${var.name_prefix}-pipeline-state-change"
  description = "Notifica via SNS cuando el pipeline cambia de estado"

  event_pattern = jsonencode({
    "source"      : ["aws.codepipeline"],
    "detail-type" : ["CodePipeline Pipeline Execution State Change"],
    "detail" : {
      "pipeline" : [var.pipeline_name],
      # Solo estados finales
      "state"    : ["SUCCEEDED", "FAILED", "STOPPED"]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.pipeline_state_change.name
  target_id = "send-to-sns"
  arn       = aws_sns_topic.pipeline_notifications.arn
}

# Permitir que EventBridge publique en el tópico
resource "aws_sns_topic_policy" "allow_events" {
  arn = aws_sns_topic.pipeline_notifications.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowEventBridgePublish"
        Effect    = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "sns:Publish"
        Resource = aws_sns_topic.pipeline_notifications.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.pipeline_state_change.arn
          }
        }
      }
    ]
  })
}
