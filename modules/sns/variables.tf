variable "name_prefix" {
  description = "Prefijo (project-environment) para nombrar recursos"
  type        = string
}

variable "pipeline_name" {
  description = "Nombre del CodePipeline a monitorear"
  type        = string
}

variable "email_subscriptions" {
  description = "Lista de emails a suscribir al tópico SNS"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}
