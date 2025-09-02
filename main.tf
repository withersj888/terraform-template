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

# Example null resource with local-exec provisioner to demonstrate functionality
resource "null_resource" "example" {
  triggers = {
    environment              = var.environment
    project_name             = var.project_name
    random_id                = random_id.example.hex
    enable_advanced_features = var.enable_advanced_features
    timestamp                = timestamp()
  }

  provisioner "local-exec" {
    command = "echo 'Module: ${local.name_prefix} | Random ID: ${random_id.example.hex} | Advanced: ${var.enable_advanced_features}' > ${var.output_directory}/module_output.txt"
  }

  lifecycle {
    create_before_destroy = true
  }
}
