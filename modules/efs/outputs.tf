output "file_system_id" {
  description = "El ID del sistema de archivos EFS"
  value       = aws_efs_file_system.main.id
}

output "access_point_id" {
  description = "El ID del punto de acceso EFS para MySQL"
  value       = aws_efs_access_point.mysql.id
}