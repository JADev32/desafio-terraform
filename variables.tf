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
