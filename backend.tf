terraform {
  backend "s3" {
    bucket  = "terraform-state-lab3-607007849260" # 
    key     = "ecs-lab3/terraform.tfstate"
    region  = "us-east-1"
    use_lockfile = true 
    encrypt = true
  }
}