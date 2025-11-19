resource "aws_ecs_task_definition" "mysql_task" {
  family                   = "${var.name}-mysql-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  volume {
    name = "mysql-data"

    efs_volume_configuration {
      file_system_id = var.efs_id
      transit_encryption = "ENABLED"
      root_directory = "/"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "mysql-db"
      image     = var.mysql_image
      essential = true

      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
        }
      ]

      environment = [
        { name = "MYSQL_ROOT_PASSWORD", value = var.db_password },
        { name = "MYSQL_DATABASE", value = var.db_name }
      ]

      mountPoints = [
        {
          containerPath = "/var/lib/mysql"
          sourceVolume  = "mysql-data"
        }
      ]
    }
  ])

  cpu    = 512
  memory = 1024
}

resource "aws_ecs_service" "mysql_service" {
  name            = "${var.name}-mysql-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.mysql_task.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.sg_db_id]
  }
}
