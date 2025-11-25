resource "aws_efs_file_system" "main" {
  creation_token = "${var.name}-efs"
  encrypted      = true

  tags = merge(var.tags, {
    Name = "${var.name}-efs"
  })
}

# Mount target en la primera subnet privada
resource "aws_efs_mount_target" "main_az1" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.private_subnet_ids[0]
  security_groups = [var.efs_security_group_id]
}

# Mount target en la segunda subnet privada
resource "aws_efs_mount_target" "main_az2" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.private_subnet_ids[1]
  security_groups = [var.efs_security_group_id]
}


resource "aws_efs_access_point" "mysql" {
  file_system_id = aws_efs_file_system.main.id

  root_directory {
    path = "/mysql-data"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-efs-ap-mysql"
  })
}