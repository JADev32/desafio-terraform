resource "aws_efs_file_system" "main" {
  creation_token = "${var.name}-efs"
  encrypted      = true

  tags = merge(var.tags, {
    Name = "${var.name}-efs"
  })
}

resource "aws_efs_mount_target" "main" {
  for_each = toset(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = each.value
  security_groups = [var.efs_security_group_id]
}

resource "aws_efs_access_point" "mysql" {
  file_system_id = aws_efs_file_system.main.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/mysql-data"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-efs-ap-mysql"
  })
}