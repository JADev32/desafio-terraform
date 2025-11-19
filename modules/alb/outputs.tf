output "alb_arn" {
  description = "ARN del Application Load Balancer."
  value       = aws_lb.application_lb.arn
}

output "alb_dns_name" {
  description = "DNS Name del Application Load Balancer."
  value       = aws_lb.application_lb.dns_name
}
