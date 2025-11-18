output "vpc_id" {
  value       = module.network.vpc_id
  description = "ID de la VPC creada."
}

output "public_subnet_ids" {
  value       = module.network.public_subnet_ids
  description = "Subnets públicas."
}

output "private_subnet_ids" {
  value       = module.network.private_subnet_ids
  description = "Subnets privadas."
}

