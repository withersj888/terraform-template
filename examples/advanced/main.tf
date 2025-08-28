# Example: Advanced Module Usage

module "example" {
  source = "../../"

  # Required variables
  environment  = var.environment
  project_name = var.project_name

  # Advanced configuration options
  enable_advanced_features = var.enable_advanced_features
  custom_configuration     = var.custom_configuration

  # Comprehensive tagging strategy
  tags = var.tags
}

# Example of using multiple module instances
module "secondary_example" {
  source = "../../"

  environment  = var.environment
  project_name = "${var.project_name}-secondary"

  # Different configuration for secondary instance
  enable_advanced_features = false

  tags = merge(var.tags, {
    Instance = "secondary"
  })
}

# Example of conditional resource creation based on module outputs
resource "local_file" "advanced_output" {
  count = var.enable_advanced_features ? 1 : 0

  content = templatefile("${path.module}/templates/advanced_config.tpl", {
    primary_output   = module.example.example_output
    secondary_output = module.secondary_example.example_output
    environment      = var.environment
  })

  filename = "${path.module}/advanced_config.txt"
}
