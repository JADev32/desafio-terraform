resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "${var.name}-frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "php-frontend"
      image     = "${var.ecr_repo_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = var.db_host
        }
      ]
    }
  ])

  cpu    = 256
  memory = 256
}

resource "aws_ecs_service" "frontend_service" {
  name            = "${var.name}-frontend-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 2

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
  }

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.sg_frontend_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "php-frontend"
    container_port   = 80
  }
}
