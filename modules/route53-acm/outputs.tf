output "record_fqdn" {
  description = "FQDN público configurado en Route 53 para el ALB."
  value       = trimsuffix(aws_route53_record.alb_alias.fqdn, ".")
}
