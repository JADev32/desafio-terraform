###############################
# ECS INSTANCE ROLE + PROFILE
###############################

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.prefix}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

######resource "aws_iam_instance_profile" "ecs_instance_profile" {
  ######name = "${var.prefix}-ecs-instance-profile"
  ######role = aws_iam_role.ecs_instance_role.name
######}

######resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  ######role       = aws_iam_role.ecs_instance_role.name
  ######policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"######
######}

##########################################
# ECS TASK EXECUTION ROLE
##########################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.prefix}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# AWS managed policy (required)
resource "aws_iam_role_policy_attachment" "ecs_task_exec_managed" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


##########################################
# Extra Policy: CloudWatch Logs (si es que los vamos a usar)
##########################################

resource "aws_iam_policy" "cw_logs_policy" {
  name = "${var.prefix}-cloudwatch-logs-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_cw" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.cw_logs_policy.arn
}


##########################################
# Extra Policy: SSM + KMS (Parameter Store)(chequear esta parte)
##########################################

resource "aws_iam_policy" "ssm_kms_policy" {
  name = "${var.prefix}-ssm-kms-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_ssm" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ssm_kms_policy.arn
}


##########################################
# CODEBUILD ROLE
##########################################

resource "aws_iam_role" "codebuild_role" {
  name = "${var.prefix}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "${var.prefix}-codebuild-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayers",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "logs:*",
        "s3:*"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}


##########################################
# CODEPIPELINE ROLE
##########################################

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.prefix}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "codepipeline_policy" {
  name = "${var.prefix}-codepipeline-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "iam:PassRole",
        "ecs:*",
        "ecr:*",
        "s3:*",
        "codebuild:*",
        "cloudwatch:*"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}
