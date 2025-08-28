output "example_output" {
  description = "Example output value from the module"
  value       = random_id.example.hex
}

output "environment" {
  description = "The environment name"
  value       = var.environment
}

output "project_name" {
  description = "The project name"
  value       = var.project_name
}

output "name_prefix" {
  description = "The generated name prefix"
  value       = local.name_prefix
}

output "common_tags" {
  description = "The common tags applied to resources"
  value       = local.common_tags
}

output "advanced_features_enabled" {
  description = "Whether advanced features are enabled"
  value       = var.enable_advanced_features
}
