# modules/ecs-service-mysql/main.tf
resource "aws_ecs_task_definition" "mysql_task" {
  family                   = "${var.name}-mysql-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  volume {
    name = "mysql-data"

    efs_volume_configuration {
      file_system_id       = var.efs_id
      transit_encryption   = "ENABLED"
      root_directory       = "/"
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
        { name = "MYSQL_DATABASE",      value = "app_db"    },
        { name = "MYSQL_ROOT_PASSWORD", value = "password" }
      ]

      mountPoints = [
        {
          containerPath = "/var/lib/mysql"
          sourceVolume  = "mysql-data"
        }
      ]
    }
  ])

  cpu    = 256
  memory = 512
}

resource "aws_ecs_service" "mysql_service" {
  name            = "${var.name}-mysql-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.mysql_task.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
    base              = 1
  }

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.sg_db_id]
  }

  service_registries {
    registry_arn = var.service_registry_arn
  }
}
