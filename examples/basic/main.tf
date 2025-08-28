# Example: Basic Module Usage

module "example" {
  source = "../../"

  # Required variables
  environment  = var.environment
  project_name = var.project_name

  # Optional variables with sensible defaults
  tags = var.tags
}

# Example of how to use module outputs
resource "local_file" "example" {
  content  = "Module output: ${module.example.example_output}"
  filename = "${path.module}/module_output.txt"
}
