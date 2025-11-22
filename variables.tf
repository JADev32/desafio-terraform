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

variable "db_host" {
  description = "Host/endpoint interno de MySQL (lo lee el frontend)."
  type        = string
}

variable "db_name" {
  description = "Nombre de la base de datos."
  type        = string

  validation {
    condition     = length(var.db_name) > 0
    error_message = "db_name no puede estar vacío."
  }
}

variable "db_user" {
  description = "Usuario de la app para la base de datos."
  type        = string

  validation {
    condition     = length(var.db_user) > 0
    error_message = "db_user no puede estar vacío."
  }
}

variable "db_pass" {
  description = "Password del usuario de la base de datos."
  type        = string
  sensitive   = true
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

