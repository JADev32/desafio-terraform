# A. Data Source: Obtener la Hosted Zone existente
data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_name
  private_zone = false
}

# B. Crear el Registro ALIAS (A) que apunta al ALB
resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"
  
  # Alias al Application Load Balancer
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}