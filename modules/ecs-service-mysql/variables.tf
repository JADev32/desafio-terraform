# modules/ecs-service-mysql/variables.tf
variable "name" {}
variable "cluster_name" {}
variable "capacity_provider_name" {}

variable "private_subnets" {
  type = list(string)
}

variable "sg_db_id" {}
variable "efs_id" {}

variable "ecs_task_execution_role_arn" {}
variable "mysql_image" {}

variable "service_registry_arn" {
  type        = string
  description = "ARN del servicio de Cloud Map para MySQL"
}
