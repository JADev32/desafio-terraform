project_name = "lab3-teracloud"
environment  = "dev"
aws_region   = "us-east-1"

db_host = "mysql.lab3.local"
db_name = "lab3db"
db_user = "lab3user"

target_group_name     = "lab3-target-group"
tg_health_check_path  = "/"
alb_name              = "lab3-alb"
acm_certificate_arn   = "arn:aws:acm:us-east-1:607007849260:certificate/5fd52e06-ddc8-415d-a888-84b872471b71"

hosted_zone_name_base = "santichamia.ownboarding.teratest.net."
