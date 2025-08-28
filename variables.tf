variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "enable_advanced_features" {
  description = "Enable advanced features of the module"
  type        = bool
  default     = false
}

variable "custom_configuration" {
  description = "Custom configuration object for advanced settings"
  type = object({
    setting_a = string
    setting_b = number
    setting_c = bool
  })
  default = {
    setting_a = "default-value"
    setting_b = 10
    setting_c = false
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "output_directory" {
  description = "The directory where generated files will be placed"
  type        = string
  default     = "/tmp"
}
