variable "name_prefix" {
  description = "Prefijo para nombres (proyecto-entorno)."
  type        = string
}

variable "aws_region" {
  description = "Región"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "ID de la cuenta (usado para nombre bucket)"
  type        = string
}

variable "codeconnection_arn" {
  description = "ARN de CodeStar Connections (para conectar GitHub/GitHub Enterprise)"
  type        = string
}

variable "github_full_repo_id" {
  description = "Full repository id en GitHub, formato owner/repo (ej. JADev32/lab2)"
  type        = string
}

variable "branch" {
  description = "Branch que dispara el pipeline"
  type        = string
  default     = "main"
}

variable "codebuild_role_arn" {
  description = "ARN del role de CodeBuild (provisionado por módulo iam)"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "ARN del role de CodePipeline (provisionado por módulo iam)"
  type        = string
}

variable "ecr_repository_name" {
  description = "Nombre del repositorio ECR (sin URI)."
  type        = string
  default     = "lab2-repo"
}

variable "image_tag" {
  description = "Tag que usará CodeBuild (default latest)"
  type        = string
  default     = "latest"
}

variable "ecs_cluster_name" {
  description = "Nombre del cluster ECS a actualizar"
  type        = string
}

variable "ecs_service_name" {
  description = "Nombre del servicio ECS a actualizar"
  type        = string
}

variable "image_definitions_path" {
  description = "Ruta del archivo image definitions (imagedefinitions.json) dentro del artifact."
  type        = string
  default     = "imagedefinitions.json"
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}