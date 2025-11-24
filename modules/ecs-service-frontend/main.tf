# modules/ecs-service-frontend/main.tf

# Log group para el frontend
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/${var.name}-frontend"
  retention_in_days = 7
  tags              = var.tags
}

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
          protocol      = "tcp"
        }
      ]

      secrets = [
        {
          name      = "DATABASE_HOST"
          valueFrom = var.db_host_arn
        },
        {
          name      = "DATABASE_NAME"
          valueFrom = var.db_name_arn
        },
        {
          name      = "DATABASE_USER"
          valueFrom = var.db_user_arn
        },
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = var.db_pass_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.frontend.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
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

  ordered_placement_strategy {
    type  = "spread" 
    field = "instanceId"
  }

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = 1
    base              = 1
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
