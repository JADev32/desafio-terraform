project_name = "lab3-teracloud"
environment  = "dev"
aws_region   = "us-east-1"

db_host = "mysql.lab3.local"
db_name = "app_db"
db_user = "root"

target_group_name     = "lab3-target-group"
tg_health_check_path  = "/"
alb_name              = "lab3-alb"
acm_certificate_arn   = "arn:aws:acm:us-east-1:607007849260:certificate/5fd52e06-ddc8-415d-a888-84b872471b71"

hosted_zone_name_base = "santichamia.ownboarding.teratest.net"

# Pipeline variables
codeconnection_arn = "arn:aws:codeconnections:us-east-1:607007849260:connection/7f088dae-e10d-4291-8f61-730e6f696dfb"
github_full_repo_id = "santinozc11/lab2-codepipeline"
github_branch       = "main"

notification_emails = [
  "santinochamia1192@gmail.com",
  "aguppesce@gmail.com",
  "maguimourino@gmail.com",
  "alladio64@gmail.com"
]
