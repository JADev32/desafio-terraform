variable "domain_name" {
  description = "FQDN del sitio (ej: lab3.santichamia.ownboarding.teratest.net.)."
  type        = string
}

variable "hosted_zone_name" {
  description = "Nombre de la Hosted Zone existente (ej: santichamia.ownboarding.teratest.net.)."
  type        = string
}

variable "alb_dns_name" {
  description = "DNS Name del ALB (ej: lab3-alb-123456.us-east-1.elb.amazonaws.com)."
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted Zone ID del ALB."
  type        = string
}
