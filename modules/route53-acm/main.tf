data "aws_route53_zone" "this" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain_name  # ya viene como lab3.santichamia.ownboarding.teratest.net.
  type    = "A"

  alias {
    name                   = var.alb_dns_name   # DNS del ALB
    zone_id                = var.alb_zone_id    # Zone ID del ALB
    evaluate_target_health = true
  }
}
