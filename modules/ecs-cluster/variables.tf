variable "name" {
  type        = string
  description = "Prefijo del cluster"
}

variable "cluster_name" {
  type        = string
  description = "Nombre del ECS Cluster"
}

variable "ami_id" {
  type        = string
  description = "AMI ECS Optimized"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2 que utilizará el cluster ECS (por ejemplo, t3.medium)."
}

variable "ecs_instance_profile_arn" {
  type        = string
  description = "ARN del Instance Profile asociado a las instancias EC2 del cluster ECS."
}

variable "private_subnets" {
  type        = list(string)
  description = "Lista de subnets privadas donde se lanzarán las instancias EC2 del cluster ECS."
}

variable "sg_ecs_hosts_id" {
  type        = string
  description = "ID del Security Group asignado a las instancias EC2 que forman parte del cluster ECS."
}

variable "tags" {
  type        = map(string)
  description = "Mapa de etiquetas (tags) que se aplicarán a los recursos creados por el módulo."
}
