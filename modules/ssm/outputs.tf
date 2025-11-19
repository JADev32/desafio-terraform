# ARNs → para usarlos en las task definitions (valueFrom)
output "db_parameters_arn" {
  description = "ARNs de los parámetros SSM de base de datos."
  value = {
    host     = aws_ssm_parameter.db_host.arn
    name     = aws_ssm_parameter.db_name.arn
    user     = aws_ssm_parameter.db_user.arn
    password = aws_ssm_parameter.db_password.arn
  }
}

# Nombres → por si quieren usar solo el name o debuggear
output "db_parameters_name" {
  description = "Nombres de los parámetros SSM de base de datos."
  value = {
    host     = aws_ssm_parameter.db_host.name
    name     = aws_ssm_parameter.db_name.name
    user     = aws_ssm_parameter.db_user.name
    password = aws_ssm_parameter.db_password.name
  }
}
