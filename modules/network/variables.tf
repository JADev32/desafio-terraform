variable "name" {
  description = "Prefijo para nombres lógicos (tags Name)."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block de la VPC."
  type        = string
}

variable "azs" {
  description = "Lista de AZs (ej. [\"us-east-1a\", \"us-east-1b\"])."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs de subnets públicas, en el mismo orden que azs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs de subnets privadas, en el mismo orden que azs."
  type        = list(string)
}

variable "tags" {
  description = "Tags comunes a aplicar."
  type        = map(string)
  default     = {}
}
