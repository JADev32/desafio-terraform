# Namespace privado: lab3.local
resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "lab3.local"
  description = "Namespace privado para servicios del lab 3"
  vpc         = var.vpc_id
}

# Servicio mysql.lab3.local
resource "aws_service_discovery_service" "mysql" {
  name = "mysql"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

