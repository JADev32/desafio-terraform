variable "name" {}
variable "cluster_name" {}

variable "private_subnets" {
  type = list(string)
}

variable "sg_db_id" {}
variable "efs_id" {}

variable "ecs_task_execution_role_arn" {}

variable "mysql_image" {}
variable "db_password" {}
variable "db_name" {}
