locals {
  # Nos aseguramos de no terminar en doble barra
  db_path = trimsuffix(var.db_parameter_path_prefix, "/")
}

# /lab3/<env>/db/host
resource "aws_ssm_parameter" "db_host" {
  name        = "${local.db_path}/host"
  description = "Host/endpoint de MySQL."
  type        = "String"
  value       = var.db_host
  overwrite   = true

  tags = merge(var.tags, {
    Name = "${var.name}-db-host"
  })
}

# /lab3/<env>/db/name
resource "aws_ssm_parameter" "db_name" {
  name        = "${local.db_path}/name"
  description = "Nombre de la base de datos."
  type        = "String"
  value       = var.db_name
  overwrite   = true

  tags = merge(var.tags, {
    Name = "${var.name}-db-name"
  })
}

# /lab3/<env>/db/user
resource "aws_ssm_parameter" "db_user" {
  name        = "${local.db_path}/user"
  description = "Usuario de la aplicación."
  type        = "String"
  value       = var.db_user
  overwrite   = true

  tags = merge(var.tags, {
    Name = "${var.name}-db-user"
  })
}

# /lab3/<env>/db/password (SecureString)
resource "aws_ssm_parameter" "db_password" {
  name        = "${local.db_path}/password"
  description = "Password del usuario de la base (SecureString)."
  type        = "SecureString"
  value       = var.db_password
  overwrite   = true
  # key_id = "alias/aws/ssm"   # opcional, default usa la key administrada de SSM

  tags = merge(var.tags, {
    Name = "${var.name}-db-password"
  })
}
