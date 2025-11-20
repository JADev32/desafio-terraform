variable "name" {}
variable "cluster_name" {}

variable "capacity_provider_name" {}
variable "private_subnets" {
  type = list(string)
}

variable "sg_frontend_id" {}
variable "target_group_arn" {}

variable "ecr_repo_url" {}
variable "image_tag" {}

variable "ecs_task_execution_role_arn" {}

variable "db_host_arn" {}
variable "db_name_arn" {}
variable "db_user_arn" {}
variable "db_pass_arn" {
  sensitive = true
}
