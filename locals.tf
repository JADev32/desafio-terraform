locals {
  # Prefijo consistente para nombrado de recursos
  name_prefix = "${var.project_name}-${var.environment}"

  # Tags comunes
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "Grupo-Lab3"
  }

  # Prefijo para SSM según ambiente (ej: /lab3/dev)
  ssm_db_prefix = "/lab3/${var.environment}"

  # AMI recomendada para ECS (Amazon Linux 2 optimizada)
  ecs_ami_id = data.aws_ssm_parameter.ecs_ami.value
}

# AMI recomendada para ECS (Amazon Linux 2 optimizada)
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

data "aws_ssm_parameter" "db_host" {
  name = "${local.ssm_db_prefix}/db_host"
}

data "aws_ssm_parameter" "db_name" {
  name = "${local.ssm_db_prefix}/db_name"
}

data "aws_ssm_parameter" "db_user" {
  name = "${local.ssm_db_prefix}/db_user"
}

data "aws_ssm_parameter" "db_pass" {
  name           = "${local.ssm_db_prefix}/db_pass"
  with_decryption = true
}
