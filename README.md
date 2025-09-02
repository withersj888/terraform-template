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
├── setup.ps1              # PowerShell setup script for development environment
├── templates/             # Template files (if needed)
├── examples/              # Usage examples
│   ├── basic/            # Basic usage example
│   └── advanced/         # Advanced usage example
├── tests/                # Terraform native tests
│   └── defaults.tftest.hcl # Basic module validation test
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

### Automated Setup (Recommended)
Run the setup script to automatically configure your development environment:

**Windows/PowerShell:**
```powershell
.\setup.ps1
```

**Linux/macOS/bash:**
```bash
./setup.sh
```

### Manual Setup
1. **Install pre-commit hooks**:
   ```powershell
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
   ```powershell
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

## Module Reference

For detailed information about module inputs, outputs, requirements, and resources, see:

**📋 [TERRAFORM_DOCS.md](./TERRAFORM_DOCS.md)** - Auto-generated module documentation

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
