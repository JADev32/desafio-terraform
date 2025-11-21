terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# S3 bucket para artifacts del pipeline
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "${var.name_prefix}-pipeline-artifacts-${replace(var.aws_account_id, "/","")}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-pipeline-artifacts" })
}

# Policy to allow CodePipeline/CodeBuild to use the bucket (minimal)
resource "aws_s3_bucket_policy" "pipeline_bucket_policy" {
  bucket = aws_s3_bucket.pipeline_artifacts.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCodeBuildCodePipelineAccess"
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.pipeline_artifacts.arn,
          "${aws_s3_bucket.pipeline_artifacts.arn}/*"
        ]
        Condition = {}
      }
    ]
  })
}

# CodeBuild project
resource "aws_codebuild_project" "build" {
  name          = "${var.name_prefix}-build"
  description   = "Build project for ${var.name_prefix}"
  service_role  = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repository_name
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = var.image_tag
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = fileexists("${path.module}/buildspec.yml") ? "${path.module}/buildspec.yml" : "buildspec.yml"
  }

  tags = var.tags
}

# CodePipeline itself
resource "aws_codepipeline" "this" {
  name     = "${var.name_prefix}-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type = "S3"
    location = aws_s3_bucket.pipeline_artifacts.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn = var.codeconnection_arn
        FullRepositoryId = var.github_full_repo_id  # e.g. "username/repo"
        BranchName = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployToECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["BuildArtifact"]

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.ecs_service_name
        FileName    = var.image_definitions_path # typically imagedefinitions.json
      }
    }
  }

  tags = var.tags
}