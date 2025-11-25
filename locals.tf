locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "Grupo-Lab3"
  }
}

# AMI recomendada para ECS (Amazon Linux 2 optimizada)
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

data "aws_ssm_parameter" "db_host" {
  name = "/lab3/db_host"
}

data "aws_ssm_parameter" "db_name" {
  name = "/lab3/db_name"
}

data "aws_ssm_parameter" "db_user" {
  name = "/lab3/db_user"
}

data "aws_ssm_parameter" "db_pass" {
  name = "/lab3/db_pass"
  with_decryption = true
}

locals {
  ecs_ami_id = data.aws_ssm_parameter.ecs_ami.value
}
