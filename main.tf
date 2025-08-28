locals {
  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "terraform"
      Module      = "terraform-template"
    },
    var.tags
  )

  name_prefix = "${var.project_name}-${var.environment}"
}

# Example resource - replace with actual resources for your module
resource "random_id" "example" {
  byte_length = 8

  keepers = {
    environment  = var.environment
    project_name = var.project_name
  }
}

# Example local file resource to demonstrate functionality
resource "local_file" "example" {
  content = templatefile("${path.module}/templates/example.tpl", {
    environment              = var.environment
    project_name             = var.project_name
    random_id                = random_id.example.hex
    enable_advanced_features = var.enable_advanced_features
    custom_configuration     = var.custom_configuration
    tags                     = local.common_tags
  })

  filename = "${path.module}/generated_example.txt"
}
