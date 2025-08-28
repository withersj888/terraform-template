output "example_output" {
  description = "Example output from the module"
  value       = module.example.example_output
}

output "environment" {
  description = "The environment name"
  value       = var.environment
}

output "project_name" {
  description = "The project name"
  value       = var.project_name
}
