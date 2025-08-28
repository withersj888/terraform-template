# Advanced Example

This example demonstrates advanced usage of the module with comprehensive configuration options.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Configuration

This example shows how to use the module with:
- Custom configuration options
- Advanced features enabled
- Multiple resource configurations
- Complex variable definitions

```hcl
module "example" {
  source = "../../"

  # Required variables
  environment  = var.environment
  project_name = var.project_name

  # Advanced configuration
  enable_advanced_features = true
  custom_configuration     = var.custom_configuration

  # Comprehensive tagging
  tags = var.tags
}
```

## Features Demonstrated

- Advanced module configuration
- Custom resource settings
- Complex variable usage
- Multi-environment support

<!-- BEGIN_TF_DOCS -->
<!-- This section will be automatically updated by terraform-docs -->
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | ../../ | n/a |
| <a name="module_secondary_example"></a> [secondary\_example](#module\_secondary\_example) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.advanced_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_configuration"></a> [custom\_configuration](#input\_custom\_configuration) | Custom configuration object for advanced settings | <pre>object({<br>    setting_a = string<br>    setting_b = number<br>    setting_c = bool<br>  })</pre> | <pre>{<br>  "setting_a": "advanced-value",<br>  "setting_b": 42,<br>  "setting_c": true<br>}</pre> | no |
| <a name="input_enable_advanced_features"></a> [enable\_advanced\_features](#input\_enable\_advanced\_features) | Enable advanced features of the module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) | `string` | `"prod"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"advanced-project"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources | `map(string)` | <pre>{<br>  "CostCentre": "engineering",<br>  "Environment": "production",<br>  "Example": "advanced",<br>  "Owner": "platform-team"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_advanced_features_enabled"></a> [advanced\_features\_enabled](#output\_advanced\_features\_enabled) | Whether advanced features are enabled |
| <a name="output_custom_configuration"></a> [custom\_configuration](#output\_custom\_configuration) | The custom configuration object |
| <a name="output_environment"></a> [environment](#output\_environment) | The environment name |
| <a name="output_primary_example_output"></a> [primary\_example\_output](#output\_primary\_example\_output) | Output from the primary module instance |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The project name |
| <a name="output_secondary_example_output"></a> [secondary\_example\_output](#output\_secondary\_example\_output) | Output from the secondary module instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
