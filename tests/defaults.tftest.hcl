# Basic test to validate module functionality
run "basic_validation" {
  command = plan

  variables {
    environment  = "dev"
    project_name = "test-project"
    tags = {
      Environment = "dev"
    }
  }

  # Test environment variable is valid
  assert {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }

  # Test project name follows naming convention
  assert {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens"
  }

  # Test required tags are present
  assert {
    condition     = can(var.tags["Environment"])
    error_message = "Environment tag should be present"
  }
}
