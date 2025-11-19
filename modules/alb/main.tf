## Creación del ALB
resource "aws_lb" "application_lb" {
  name               = var.alb_name
  internal           = false # Para que sea accesible desde internet (público)
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids
  ip_address_type    = "ipv4"

  tags = {
    Name = var.alb_name
    Owner = var.alb_owner
  }
}

## Listener HTTPS (443)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
}

## Listener HTTP (80) con redirección automática a HTTPS (443)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301" # Redirección permanente
    }
  }
}

