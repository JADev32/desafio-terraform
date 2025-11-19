variable "name" {
  description = "Prefijo para el nombrado de recursos"
  type        = string
}

variable "tags" {
  description = "Mapa de tags adicionales"
  type        = map(string)
  default     = {}
}
