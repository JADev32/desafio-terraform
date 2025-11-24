terraform {
  required_version = ">= 1.9.0"

  backend "s3" {
    bucket       = "terraform-state-lab3-607007849260" # 
    key          = "ecs-lab3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
  

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

data "aws_caller_identity" "current" {}
