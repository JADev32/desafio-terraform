##########################################
# ECS Launch Template
##########################################

resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "${var.name}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    arn = var.ecs_instance_profile_arn
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
  )

  # Las instancias van en subnets privadas vía el ASG,
  # así que no necesitamos tocar associate_public_ip acá.
  vpc_security_group_ids = [var.sg_ecs_hosts_id]

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name             = "${var.name}-ecs-instance"
      AmazonECSManaged = "true"
    })
  }
}

##########################################
# Auto Scaling Group para ECS (EC2)
##########################################

resource "aws_autoscaling_group" "ecs_asg" {
  name                = "${var.name}-asg"
  max_size            = 5
  min_size            = 3
  desired_capacity    = 3
  vpc_zone_identifier = var.private_subnets
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-ecs-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

##########################################
# ECS Cluster
##########################################

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

##########################################
# Capacity Provider
##########################################

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "${var.cluster_name}-capacity"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      status = "ENABLED"
    }

    managed_termination_protection = "DISABLED"
  }
}

##########################################
# Asociar Capacity Provider al Cluster
##########################################

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_cp" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 1
    base              = 1
  }
}
