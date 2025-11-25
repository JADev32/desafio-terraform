variable "prefix" {
  description = "Prefix for all IAM resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "efs_id" {
  description = "EFS File System ID"
  type        = string
}
