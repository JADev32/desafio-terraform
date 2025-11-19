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

variable "db_password" {
  description = "Password del usuario de la base de datos."
  type        = string
  sensitive   = true
}
