variable "name" {
  description = "Prefijo para nombres lógicos (tags Name)."
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crean los SG."
  type        = string
}

variable "vpc_dns_resolver_cidr" {
  description = "CIDR del resolver de la VPC (por ej: 10.0.0.2/32)."
  type        = string
}

variable "tags" {
  description = "Tags comunes."
  type        = map(string)
  default     = {}
}
