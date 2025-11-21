# modules/ecs-service-frontend/variables.tf

variable "name" {
  description = "Nombre base o prefijo que se usará para nombrar los recursos (ECS Service, Task Definition, etc.)."
  type        = string
}

variable "cluster_name" {
  description = "Nombre del clúster ECS donde se desplegará el servicio frontend."
  type        = string
}

variable "capacity_provider_name" {
  description = "Nombre del Capacity Provider a utilizar para escalar el servicio ECS (ej. 'FARGATE' o un nombre de ASG)."
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs de las subredes privadas donde se desplegará la tarea ECS (para asegurar que el tráfico pase por el ALB y NAT/IGW)."
  type        = list(string)
}

variable "sg_frontend_id" {
  description = "ID del Security Group (Grupo de Seguridad) que será asignado al servicio frontend para controlar el acceso."
  type        = string
}

variable "target_group_arn" {
  description = "ARN del Target Group del Application Load Balancer (ALB) al que se vinculará este servicio ECS."
  type        = string
}

variable "ecr_repo_url" {
  description = "URL completa del repositorio ECR donde se encuentra la imagen del frontend (ej. '123456789012.dkr.ecr.us-east-1.amazonaws.com/app/frontend')."
  type        = string
}

variable "image_tag" {
  description = "Tag (etiqueta) específica de la imagen Docker a desplegar (ej. 'latest' o un hash de commit)."
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN del rol de ejecución de tarea de ECS (ECS Task Execution Role) que otorga permisos para extraer la imagen y publicar logs."
  type        = string
}

variable "db_host_arn" {
  description = "ARN del secreto en Secrets Manager que contiene el Hostname/Endpoint de la base de datos."
  type        = string
}

variable "db_name_arn" {
  description = "ARN del secreto en Secrets Manager que contiene el nombre de la base de datos (DB Name)."
  type        = string
}

variable "db_user_arn" {
  description = "ARN del secreto en Secrets Manager que contiene el nombre de usuario de la base de datos."
  type        = string
}

variable "db_pass_arn" {
  description = "ARN del secreto en Secrets Manager que contiene la contraseña de la base de datos. Está marcado como sensible."
  type        = string
  sensitive   = true
}
