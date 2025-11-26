output "pipeline_name" {
  description = "Nombre del pipeline CI/CD"
  value       = aws_codepipeline.this.name
}
