# Terraform Module Template

This repository serves as a template for creating gold standard Terraform modules that follow industry best practices and HashiCorp's official guidelines.

## Quick Start

1. **Clone this template**: Use this repository as a template for your new Terraform module
2. **Update module files**: Replace the example resources in `main.tf` with your actual infrastructure resources
3. **Configure variables**: Update `variables.tf` with your module's input variables
4. **Define outputs**: Update `outputs.tf` with the values your module should return
5. **Update documentation**: Modify this README and run `terraform-docs` to generate documentation
6. **Add examples**: Create working examples in the `examples/` directory
7. **Set up CI/CD**: Configure the GitHub Actions workflow for your specific needs

## Module Structure

This template follows the standard Terraform module structure:

```
├── main.tf                 # Primary resource definitions
├── variables.tf            # Input variable declarations
├── outputs.tf             # Output declarations
├── versions.tf            # Provider and Terraform version constraints
├── templates/             # Template files (if needed)
├── examples/              # Usage examples
│   ├── basic/            # Basic usage example
│   └── advanced/         # Advanced usage example
├── .github/              # GitHub templates and workflows
├── .terraform-docs.yml   # Terraform-docs configuration
├── .tflint.hcl          # TFLint configuration
├── .pre-commit-config.yaml # Pre-commit hooks
└── TERRAFORM_MODULE_STANDARDS.md # Detailed standards guide
```

## Usage

### Basic Example

```hcl
module "example" {
  source = "path/to/this/module"

  environment  = "dev"
  project_name = "my-project"

  tags = {
    Owner = "platform-team"
  }
}
```

### Advanced Example

```hcl
module "example" {
  source = "path/to/this/module"

  environment  = "prod"
  project_name = "my-project"

  enable_advanced_features = true
  custom_configuration = {
    setting_a = "custom-value"
    setting_b = 100
    setting_c = true
  }

  tags = {
    Owner       = "platform-team"
    CostCentre  = "engineering"
    Environment = "production"
  }
}
```

## Documentation Standards

This template includes comprehensive documentation standards. See [`TERRAFORM_MODULE_STANDARDS.md`](./TERRAFORM_MODULE_STANDARDS.md) for detailed guidelines covering:

- Module structure and file organisation
- Naming conventions
- Code quality standards
- Testing requirements
- Security best practices
- Release management
- CI/CD pipeline configuration

## Development Setup

1. **Install pre-commit hooks**:
   ```bash
   pip install pre-commit
   pre-commit install
   ```

2. **Install required tools**:
   - [Terraform](https://www.terraform.io/downloads.html)
   - [terraform-docs](https://terraform-docs.io/user-guide/installation/)
   - [TFLint](https://github.com/terraform-linters/tflint)
   - [Checkov](https://www.checkov.io/2.Basics/Installing%20Checkov.html)
   - [tfsec](https://aquasecurity.github.io/tfsec/v1.28.1/getting-started/installation/)

3. **Run validation**:
   ```bash
   terraform fmt -recursive
   terraform init
   terraform validate
   tflint --recursive
   checkov -d .
   ```

## Testing

Run the example configurations to test the module:

```bash
# Test basic example
cd examples/basic
terraform init
terraform plan

# Test advanced example
cd ../advanced
terraform init
terraform plan
```

## Contributing

1. Follow the standards outlined in `TERRAFORM_MODULE_STANDARDS.md`
2. Ensure all pre-commit hooks pass
3. Add tests for new functionality
4. Update documentation as needed
5. Submit a pull request using the provided template

<!-- BEGIN_TF_DOCS -->
## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

## Modules

No modules.

## Resources

## Resources

| Name | Type |
|------|------|
| [local_file.example](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_id.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_configuration"></a> [custom\_configuration](#input\_custom\_configuration) | Custom configuration object for advanced settings | <pre>object({<br>    setting_a = string<br>    setting_b = number<br>    setting_c = bool<br>  })</pre> | <pre>{<br>  "setting_a": "default-value",<br>  "setting_b": 10,<br>  "setting_c": false<br>}</pre> | no |
| <a name="input_enable_advanced_features"></a> [enable\_advanced\_features](#input\_enable\_advanced\_features) | Enable advanced features of the module | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g., dev, staging, prod) | `string` | n/a | yes |
| <a name="input_output_directory"></a> [output\_directory](#input\_output\_directory) | The directory where generated files will be placed | `string` | `"/tmp"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_advanced_features_enabled"></a> [advanced\_features\_enabled](#output\_advanced\_features\_enabled) | Whether advanced features are enabled |
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | The common tags applied to resources |
| <a name="output_environment"></a> [environment](#output\_environment) | The environment name |
| <a name="output_example_output"></a> [example\_output](#output\_example\_output) | Example output value from the module |
| <a name="output_name_prefix"></a> [name\_prefix](#output\_name\_prefix) | The generated name prefix |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | The project name |
<!-- END_TF_DOCS -->

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
