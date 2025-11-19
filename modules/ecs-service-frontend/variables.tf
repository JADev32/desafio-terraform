variable "name" {}
variable "cluster_name" {}

variable "capacity_provider_name" {}
variable "private_subnets" {
  type = list(string)
}

variable "sg_frontend_id" {}
variable "vpc_id" {}
variable "alb_listener_arn" {}

variable "ecr_repo_url" {}
variable "image_tag" {}

variable "ecs_task_execution_role_arn" {}

variable "db_host" {}
