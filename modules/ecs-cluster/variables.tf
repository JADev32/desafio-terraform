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
}

variable "ecs_instance_profile_arn" {
  type        = string
}

variable "private_subnets" {
  type = list(string)
}

variable "sg_ecs_hosts_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
