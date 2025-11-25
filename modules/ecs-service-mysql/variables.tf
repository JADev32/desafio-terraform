# modules/ecs-service-mysql/variables.tf
variable "name" {
  description = "Nombre base que se usará como prefijo para nombrar los recursos (ECS Service, Task Definition, etc.)."
  type        = string
}

variable "cluster_name" {
  description = "Nombre del clúster ECS donde se desplegará el servicio MySQL."
  type        = string
}

variable "capacity_provider_name" {
  description = "Nombre del capacity provider del cluster ECS"
  type        = string
}

variable "private_subnets" {
  description = "Lista de IDs de las subredes privadas donde se desplegará la tarea ECS (MySQL)."
  type        = list(string)
}

variable "sg_db_id" {
  description = "ID del Security Group (Grupo de Seguridad) que será asignado al servicio MySQL para controlar el tráfico entrante/saliente."
  type        = string
}

variable "efs_id" {
  description = "ID del sistema de archivos EFS que se montará en la tarea MySQL para la persistencia de datos."
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN del rol de ejecución de tarea de ECS (ECS Task Execution Role) que otorga permisos para extraer la imagen y publicar logs."
  type        = string
}

variable "mysql_image" {
  description = "Nombre o URI de la imagen Docker de MySQL que se utilizará para el contenedor (ej. 'mysql/mysql-server:8.0')."
  type        = string
}

variable "service_registry_arn" {
  type        = string
  description = "ARN del servicio de Cloud Map para MySQL al que se registrará el servicio ECS (para service discovery)."
}

variable "mysql_database" {
  description = "Nombre de la base de datos MySQL"
  type        = string
}

variable "mysql_root_password" {
  description = "Contraseña root de MySQL"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "Región de AWS (para logs)"
  type        = string
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}

variable "efs_access_point_id" {
  description = "ID del punto de acceso de EFS para la tarea MySQL."
  type        = string
  
}