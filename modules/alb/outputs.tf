output "alb_arn" {
  description = "ARN del Application Load Balancer."
  value       = aws_lb.application_lb.arn
}

output "alb_zone_id" {
  description = "La Zone ID del Application Load Balancer (necesaria para el registro Alias de Route53)."
  value       = aws_lb.application_lb.zone_id
}

output "alb_dns_name" {
  description = "DNS Name del Application Load Balancer."
  value       = aws_lb.application_lb.dns_name
}
