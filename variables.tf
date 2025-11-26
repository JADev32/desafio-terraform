variable "project_name" {
  description = "Nombre del proyecto para tags y nombres lógicos."
  type        = string
  default     = "lab3-teracloud"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name solo puede tener minúsculas, números y guiones (ej: lab3-teracloud)."
  }
}

variable "environment" {
  description = "Ambiente (dev, prod, etc.)."
  type        = string
  default     = "dev"


  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment debe ser uno de: dev, prod."
  }
}

variable "aws_region" {
  description = "Región de AWS."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "aws_region no puede estar vacío."
  }
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
  default     = ""
}

#variable route
variable "hosted_zone_name_base" {
  description = "El nombre base de la Hosted Zone existente en Route 53 (ej: santichamia.ownboarding.teratest.net.)."
  type        = string
}

#variable img front
variable "frontend_image_tag" {
  description = "Tag de la imagen del frontend en ECR"
  type        = string
  default     = "latest"
}

# Pipeline variables
variable "codeconnection_arn" {
  description = "ARN de CodeStar Connections para GitHub"
  type        = string
}

variable "github_full_repo_id" {
  description = "Full repository id en GitHub, formato owner/repo"
  type        = string
}

variable "github_branch" {
  description = "Branch que dispara el pipeline"
  type        = string
  default     = "main"
}

variable "notification_emails" {
  description = "Lista de emails para notificaciones SNS del pipeline"
  type        = list(string)
  default     = []
}

# Network variables
variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type        = list(string)
}
