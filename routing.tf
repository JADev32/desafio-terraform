# routing.tf

# 5) Target Group (TG)
module "target_group" {
  source = "./modules/tg"

  vpc_id = module.network.vpc_id

  name              = var.target_group_name
  health_check_path = var.tg_health_check_path
}

# 6) Application Load Balancer (ALB)
module "application_load_balancer" {
  source = "./modules/alb"

  alb_name  = var.alb_name
  alb_owner = "Magali"

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  security_group_ids = [module.security.sg_alb_id]

  target_group_arn    = module.target_group.target_group_arn
  acm_certificate_arn = length(data.aws_acm_certificate.cert) > 0 ? data.aws_acm_certificate.cert[0].arn : var.acm_certificate_arn
}

# 9) Route 53 
module "route53_record" {
  source = "./modules/route53-acm"

  domain_name      = "lab3.${trim(var.hosted_zone_name_base, ".")}"
  hosted_zone_name = trim(var.hosted_zone_name_base, ".")

  # Valores obtenidos del output del módulo ALB
  alb_dns_name = module.application_load_balancer.alb_dns_name
  alb_zone_id  = module.application_load_balancer.alb_zone_id
}
