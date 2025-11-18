output "vpc_id" {
  description = "ID de la VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR de la VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs de subnets públicas."
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "IDs de subnets privadas."
  value       = [for s in aws_subnet.private : s.id]
}

output "internet_gateway_id" {
  description = "ID del IGW."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "ID del NAT."
  value       = aws_nat_gateway.this.id
}

output "public_route_table_id" {
  description = "Route table pública."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Route tables privadas."
  value       = [for r in aws_route_table.private : r.id]
}
