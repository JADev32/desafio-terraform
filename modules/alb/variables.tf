variable "alb_name" {
  description = "El nombre del Application Load Balancer."
  type        = string
  default     = "alb-lab2"
}

variable "vpc_id" {
  description = "El ID de la VPC donde se desplegará el ALB."
  type        = string
}

variable "public_subnet_ids" {
  description = "Lista de IDs de las subredes públicas para el ALB."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Lista de IDs de los Security Groups para el ALB."
  type        = list(string)
}

variable "target_group_arn" {
  description = "El ARN del Target Group (ya creado) al que se asociará el ALB."
  type        = string
}

variable "acm_certificate_arn" {
  description = "El ARN del certificado de ACM para el Listener HTTPS (443)."
  type        = string
}

variable "alb_owner" {
  description = "Identificador del responsable del ALB."
  type        = string
}
