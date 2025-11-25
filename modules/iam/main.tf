# Data source para obtener el account ID
data "aws_caller_identity" "current" {}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}


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

# Sin el instance profile no se puede asociar el rol a las instancias EC2 del ASG/Launch Template, por eso lo descomento para usarlo.
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.prefix}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

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
  name = "${var.prefix}-ssm-kms-policy-v2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ReadLab3Params"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
Resource = "*"
      },
      {
        Sid = "DecryptSSM"
        Effect = "Allow"
        Action = "kms:Decrypt"
        Resource = "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:alias/aws/ssm"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_ssm" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ssm_kms_policy.arn
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

resource "aws_iam_role_policy" "codepipeline_inline" {
  name = "${var.prefix}-codepipeline-inline"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowS3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Resource = "arn:aws:s3:::${var.prefix}-pipeline-artifacts-*"
      },
      {
        Sid = "AllowS3ObjectAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "arn:aws:s3:::${var.prefix}-pipeline-artifacts-*/*"
      },
      {
        Sid = "CodeBuildPermissions"
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch"
        ]
        Resource = "arn:aws:codebuild:${var.aws_region}:${data.aws_caller_identity.current.account_id}:project/${var.prefix}-*"
      },
      {
        Sid = "CodeConnectionsPermissions"
        Effect = "Allow"
        Action = [
          "codeconnections:UseConnection",
          "codestar-connections:UseConnection"
        ]
        Resource = [
          "arn:aws:codeconnections:${var.aws_region}:${data.aws_caller_identity.current.account_id}:connection/*",
          "arn:aws:codestar-connections:${var.aws_region}:${data.aws_caller_identity.current.account_id}:connection/*"
        ]
      },
      {
        Sid = "TaskDefinitionPermissions"
        Effect = "Allow"
        Action = [
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition"
        ]
        Resource = "*"
      },
      {
        Sid = "ECSServicePermissions"
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService"
        ]
        Resource = "arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${var.prefix}-*/*"
      },
      {
        Sid = "ECSTagResource"
        Effect = "Allow"
        Action = "ecs:TagResource"
        Resource = "*"
        Condition = {
          StringEquals = {
            "ecs:CreateAction" = "RegisterTaskDefinition"
          }
        }
      },
      {
        Sid = "IamPassRolePermissions"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.prefix}-ecs-task-execution-role"
        Condition = {
          StringEquals = {
            "iam:PassedToService" = [
              "ecs.amazonaws.com",
              "ecs-tasks.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
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
  name = "${var.prefix}-codebuild-policy-v2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "CloudWatchLogsPermissions"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.prefix}-*",
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/${var.prefix}-*:*"
        ]
      },
      {
        Sid = "S3ArtifactsPermissions"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "arn:aws:s3:::${var.prefix}-pipeline-artifacts-*",
          "arn:aws:s3:::${var.prefix}-pipeline-artifacts-*/*"
        ]
      },
      {
        Sid = "ECRPermissions"
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = "*"
      },
      {
        Sid = "CodeBuildReportsPermissions"
        Effect = "Allow"
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Resource = "arn:aws:codebuild:${var.aws_region}:${data.aws_caller_identity.current.account_id}:report-group/${var.prefix}-*"
      },
      {
        Sid = "SSMParametersPermissions"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_role" "ecs_efs_access" {
name = "ecs-efs-access-role"

assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Effect = "Allow"
Principal = {
Service = "ec2.amazonaws.com"
}
Action = "sts:AssumeRole"
}
]
})
}

resource "aws_iam_policy" "ecs_efs_policy" {
name        = "ecs-efs-policy"
description = "Permisos para ECS montar EFS Access Point"

policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Effect = "Allow"
Action = [
"elasticfilesystem:ClientMount",
"elasticfilesystem:ClientWrite",
"elasticfilesystem:ClientRootAccess"
]
Resource = "*"
}
]
})
}

resource "aws_iam_role_policy_attachment" "ecs_efs_attach" {
role       = aws_iam_role.ecs_efs_access.name
policy_arn = aws_iam_policy.ecs_efs_policy.arn
}

resource "aws_iam_role" "ecs_task_mysql_role" {
  name = "ecs-task-mysql-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_task_mysql_policy" {
  name        = "ecs-task-mysql-policy"
  description = "Permisos para montar EFS desde Task Definition"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRootAccess"
        ]
        Resource = "arn:aws:elasticfilesystem:${var.aws_region}:${data.aws_caller_identity.current.account_id}:file-system/${var.efs_id}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_mysql_attach" {
  role       = aws_iam_role.ecs_task_mysql_role.name
  policy_arn = aws_iam_policy.ecs_task_mysql_policy.arn
}


