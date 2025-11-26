variable "name" {
  description = "Nombre del Target Group."
  type        = string
  default     = "lab3-target-group"
}

variable "vpc_id" {
  description = "El ID de la VPC donde se desplegará el Target Group."
  type        = string
}

variable "port" {
  description = "Puerto de escucha para el tráfico."
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocolo del tráfico (HTTP, HTTPS, etc)."
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Ruta para el Health Check."
  type        = string
  default     = "/"
}