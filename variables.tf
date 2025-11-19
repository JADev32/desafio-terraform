variable "project_name" {
  description = "Nombre del proyecto para tags y nombres lógicos."
  type        = string
  default     = "lab3-teracloud"
}

variable "environment" {
  description = "Ambiente (dev, prod, etc.)."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Región de AWS."
  type        = string
  default     = "us-east-1"
}

## variables target group
variable "target_group_name" {
  description = "El nombre deseado para el Target Group (ej: lab3-target-group)."
  type        = string
}

variable "tg_health_check_path" {
  description = "La ruta para el Health Check del Target Group (ej: /css/twitter.css)."
  type        = string
}

## variables alb
variable "alb_name" {
  description = "Nombre que se asignará al Application Load Balancer."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN del certificado de ACM para el listener HTTPS."
  type        = string
}