output "cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.ecs_capacity_provider.name
}
