variable "domain_name" {
  description = "El nombre de subdominio (ej: lab3.santichamia.ownboarding.teratest.net) a crear."
  type        = string
}

variable "hosted_zone_name" {
  description = "Nombre exacto de la Hosted Zone existente."
  type        = string
  default     = "santichamia.ownboarding.teratest.net."
}

variable "alb_zone_id" {
  description = "El Zone ID del Application Load Balancer."
  type        = string
}

variable "alb_dns_name" {
  description = "El DNS Name del Application Load Balancer (necesario para el alias)."
  type        = string
}