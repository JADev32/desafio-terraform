variable "environment" {
  description = "Nombre del entorno de despliegue"
  type        = string
  default     = "dev"
}

variable "name" {
  description = "Prefijo para el nombrado de recursos"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subnets privadas para los Mount Targets"
  type        = list(string)
}

variable "efs_security_group_id" {
  description = "ID del Security Group asignado al EFS"
  type        = string
}

variable "tags" {
  description = "Mapa de tags adicionales"
  type        = map(string)
  default     = {}
}