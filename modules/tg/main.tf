resource "aws_lb_target_group" "app_tg" {
  name             = var.name
  port             = var.port
  protocol         = var.protocol
  vpc_id           = var.vpc_id
  target_type      = "ip" 
  
  # Configuración del Health Check
  health_check {
    protocol            = "HTTP" # El Health Check es HTTP
    path                = var.health_check_path
    port                = "traffic-port" # Revisa el puerto de tráfico
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.name
  }
}

