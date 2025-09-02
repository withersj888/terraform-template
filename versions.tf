terraform {
  # Require Terraform 1.6.0+ for native testing support
  # Upper bound is a precaution to prevent future breaking changes if Terraform 2.0.0+ is released
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    null = {
      source = "hashicorp/null"
      # Pin to specific version range for stability
      version = ">= 3.2.0, < 4.0.0"
    }
    random = {
      source = "hashicorp/random"
      # Pin to specific version range for stability
      version = ">= 3.7.0, < 4.0.0"
    }
  }

  # Dependency lock file management
  # Run 'terraform providers lock' to update lock file
  # This ensures consistent provider versions across environments
}
