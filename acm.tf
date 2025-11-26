locals {
  cert_domain = "*.${trim(var.hosted_zone_name_base, ".") }"
}

data "aws_acm_certificate" "cert" {
  count       = var.acm_certificate_arn == "" ? 1 : 0
  domain      = local.cert_domain
  most_recent = true
  statuses    = ["ISSUED"]
}

output "resolved_acm_certificate_arn" {
  description = "ARN resuelto a partir de la fuente de datos ACM (vacío si se proporciona variable)."
  value = (
    length(data.aws_acm_certificate.cert) > 0 ? data.aws_acm_certificate.cert[0].arn : (var.acm_certificate_arn != "" ? var.acm_certificate_arn : "")
  )
}
