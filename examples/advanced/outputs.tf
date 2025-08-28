output "primary_example_output" {
  description = "Output from the primary module instance"
  value       = module.example.example_output
}

output "secondary_example_output" {
  description = "Output from the secondary module instance"
  value       = module.secondary_example.example_output
}

output "environment" {
  description = "The environment name"
  value       = var.environment
}

output "project_name" {
  description = "The project name"
  value       = var.project_name
}

output "advanced_features_enabled" {
  description = "Whether advanced features are enabled"
  value       = var.enable_advanced_features
}

output "custom_configuration" {
  description = "The custom configuration object"
  value       = var.custom_configuration
  sensitive   = false
}
