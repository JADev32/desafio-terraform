# SG del ALB
resource "aws_security_group" "alb" {
  name        = "${var.name}-sg-alb"
  description = "Security Group del ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-sg-alb"
    Role = "alb"
  })
}

# SG del frontend (servicio ECS frontend)
resource "aws_security_group" "frontend" {
  name        = "${var.name}-sg-frontend"
  description = "Security Group del servicio frontend"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-sg-frontend"
    Role = "frontend"
  })
}

# SG del MySQL (servicio ECS mysql)
resource "aws_security_group" "db" {
  name        = "${var.name}-sg-db"
  description = "Security Group del servicio MySQL"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-sg-db"
    Role = "db"
  })
}

# SG de EFS
resource "aws_security_group" "efs" {
  name        = "${var.name}-sg-efs"
  description = "Security Group del file system EFS"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-sg-efs"
    Role = "efs"
  })
}

# SG de las instancias EC2 del cluster ECS
resource "aws_security_group" "ecs_hosts" {
  name        = "${var.name}-sg-ecs-hosts"
  description = "Security Group de las instancias EC2 del cluster ECS"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-sg-ecs-hosts"
    Role = "ecs-hosts"
  })
}

#############################
# Reglas sg-alb
#############################

# HTTP desde Internet
resource "aws_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# HTTPS desde Internet
resource "aws_security_group_rule" "alb_ingress_https" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Egreso del ALB hacia el frontend (HTTP 80)
resource "aws_security_group_rule" "alb_egress_to_frontend" {
  type                     = "egress"
  security_group_id        = aws_security_group.alb.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.frontend.id
}

#############################
# Reglas sg-frontend
#############################

# Ingreso HTTP solo desde el ALB
resource "aws_security_group_rule" "frontend_ingress_http" {
  type                     = "ingress"
  security_group_id        = aws_security_group.frontend.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
}

# Egreso DNS (TCP) al resolver de la VPC
resource "aws_security_group_rule" "frontend_egress_dns_tcp" {
  type              = "egress"
  security_group_id = aws_security_group.frontend.id
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_dns_resolver_cidr]
}

# Egreso DNS (UDP) al resolver de la VPC
resource "aws_security_group_rule" "frontend_egress_dns_udp" {
  type              = "egress"
  security_group_id = aws_security_group.frontend.id
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [var.vpc_dns_resolver_cidr]
}

# Egreso MySQL hacia sg-db
resource "aws_security_group_rule" "frontend_egress_mysql" {
  type                     = "egress"
  security_group_id        = aws_security_group.frontend.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db.id
}

# Egreso HTTPS a internet (para salir por NAT a ECR, ACM, etc.)
resource "aws_security_group_rule" "frontend_egress_https" {
  type              = "egress"
  security_group_id = aws_security_group.frontend.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

#############################
# Reglas sg-db
#############################

# Ingreso MySQL solo desde el frontend
resource "aws_security_group_rule" "db_ingress_mysql" {
  type                     = "ingress"
  security_group_id        = aws_security_group.db.id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.frontend.id
}

# Egreso NFS hacia sg-efs
resource "aws_security_group_rule" "db_egress_nfs" {
  type                     = "egress"
  security_group_id        = aws_security_group.db.id
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs.id
}

# Egreso DNS (TCP) al resolver
resource "aws_security_group_rule" "db_egress_dns_tcp" {
  type              = "egress"
  security_group_id = aws_security_group.db.id
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_dns_resolver_cidr]
}

# Egreso DNS (UDP) al resolver
resource "aws_security_group_rule" "db_egress_dns_udp" {
  type              = "egress"
  security_group_id = aws_security_group.db.id
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [var.vpc_dns_resolver_cidr]
}

#############################
# Reglas sg-efs
#############################

# Ingreso NFS solo desde sg-db
resource "aws_security_group_rule" "efs_ingress_nfs" {
  type                     = "ingress"
  security_group_id        = aws_security_group.efs.id
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db.id
}

#############################
# Reglas sg-ecs-hosts
#############################

# Egreso DNS (TCP) al resolver
resource "aws_security_group_rule" "ecs_hosts_egress_dns_tcp" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_hosts.id
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_dns_resolver_cidr]
}

# Egreso DNS (UDP) al resolver
resource "aws_security_group_rule" "ecs_hosts_egress_dns_udp" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_hosts.id
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  cidr_blocks       = [var.vpc_dns_resolver_cidr]
}

# Egreso HTTPS a internet (updates, ECR, SSM, etc.)
resource "aws_security_group_rule" "ecs_hosts_egress_https" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_hosts.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
