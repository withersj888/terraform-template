# Basic Example

This example demonstrates the basic usage of the module with minimal configuration.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Configuration

```hcl
module "example" {
  source = "../../"

  # Minimal required variables
  environment  = var.environment
  project_name = var.project_name

  # Optional tags
  tags = var.tags
}
```

## Outputs

The example outputs the important resource identifiers that you might need for further configuration.

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

## Resources

| Name | Type |
|------|------|
| [local_file.example](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) | `string` | `"dev"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | `"example-project"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources | `map(string)` | <pre>{<br>  "Example": "basic",<br>  "Owner": "platform-team"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment"></a> [environment](#output\_environment) | The environment name |
| <a name="output_example_output"></a> [example\_output](#output\_example\_output) | Example output from the module |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The project name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
