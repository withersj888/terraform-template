terraform {
  # Require Terraform 1.6.0+ for native testing support
  # Upper bound prevents breaking changes in major versions
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    local = {
      source = "hashicorp/local"
      # Pin to specific version range for stability
      version = ">= 2.5.0, < 3.0.0"
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
