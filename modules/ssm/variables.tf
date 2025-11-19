variable "name" {
  description = "Prefijo lógico para nombres (ej: lab3-teracloud-dev)."
  type        = string
}

variable "db_parameter_path_prefix" {
  description = "Prefijo en SSM para los parámetros de DB (ej: /lab3/dev/db)."
  type        = string
}

variable "db_host" {
  description = "Host/endpoint de MySQL que consumirá el frontend."
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
  description = "Usuario de la aplicación para la base de datos."
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

variable "tags" {
  description = "Tags comunes."
  type        = map(string)
  default     = {}
}
