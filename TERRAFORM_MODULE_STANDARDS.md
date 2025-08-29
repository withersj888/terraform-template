# Gold Standard Terraform Module Guidelines

This document outlines the standards and best practices for creating high-quality, production-ready Terraform modules that follow industry best practices and HashiCorp's official guidelines.

## Table of Contents

- [Module Structure](#module-structure)
- [File Organisation](#file-organisation)
- [Naming Conventions](#naming-conventions)
- [Documentation Requirements](#documentation-requirements)
- [Code Quality Standards](#code-quality-standards)
- [Testing Requirements](#testing-requirements)
- [Security Best Practices](#security-best-practices)
- [Release Management](#release-management)
- [Examples and Usage](#examples-and-usage)
- [Validation and CI/CD](#validation-and-cicd)

## Module Structure

Every Terraform module should follow this standardised directory structure:

```
terraform-module-name/
├── README.md                 # Primary documentation
├── main.tf                   # Primary resource definitions
├── variables.tf              # Input variable declarations
├── outputs.tf                # Output declarations
├── versions.tf               # Provider and Terraform version constraints
├── locals.tf                 # Local value definitions (if needed)
├── data.tf                   # Data source definitions (if needed)
├── CHANGELOG.md              # Release notes and version history
├── LICENSE                   # Module licence
├── .gitignore               # Git ignore rules
├── .terraform-docs.yml       # Terraform-docs configuration
├── .tflint.hcl              # TFLint configuration
├── .pre-commit-config.yaml   # Pre-commit hooks configuration
├── examples/                 # Usage examples
│   ├── basic/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── advanced/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
├── tests/                    # Automated tests
│   ├── unit/
│   └── integration/
└── modules/                  # Sub-modules (if applicable)
    └── sub-module-name/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── README.md
```

## File Organisation

### main.tf
- Contains the primary resource definitions
- Resources should be logically grouped and ordered
- Use consistent resource naming patterns
- Include appropriate tags on all resources

### variables.tf
- All input variables with descriptions, types, and default values where appropriate
- Variables should be ordered alphabetically or by logical grouping
- Use validation blocks for input validation
- Mark sensitive variables appropriately

### outputs.tf
- All output values that consumers might need
- Include descriptions for all outputs
- Consider what information would be useful for dependent modules

### versions.tf
- Terraform version constraints
- Provider version constraints with specific version ranges
- Required providers block with source and version

## Naming Conventions

### Module Names
- Use kebab-case: `terraform-<provider>-<resource>`
- Example: `terraform-aws-vpc`, `terraform-azure-storage-account`

### Resource Names
- Use descriptive names that indicate purpose
- Prefix with module purpose: `vpc_main`, `subnet_private`, `sg_web`
- Avoid generic names like `this`, `main`, `default`

### Variables and Outputs
- Use snake_case consistently
- Be descriptive and specific
- Group related variables with common prefixes

### Tags
- Implement consistent tagging strategy
- Include standard tags: `Environment`, `Project`, `Owner`, `ManagedBy`
- Use locals to define common tags

## Documentation Requirements

### README.md Structure
```markdown
# Module Name

Brief description of what the module does.

## Usage

Basic usage example with minimal configuration.

## Examples

Links to example implementations in the examples/ directory.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

Auto-generated providers table.

## Modules

Auto-generated modules table (if applicable).

## Resources

Auto-generated resources table.

## Inputs

Auto-generated inputs table.

## Outputs

Auto-generated outputs table.

## License

License information.
```

### Code Documentation
- All variables must have descriptions
- All outputs must have descriptions
- Complex logic should include inline comments
- Use terraform-docs to auto-generate documentation

## Code Quality Standards

### Formatting and Style
- Use `terraform fmt` for consistent formatting
- Maximum line length of 120 characters
- Consistent indentation (2 spaces)
- Logical grouping of resources with blank lines

### Variables Best Practices
```hcl
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
```

### Locals Usage
```hcl
locals {
  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "terraform"
      Module      = "terraform-aws-vpc"
    },
    var.tags
  )

  name_prefix = "${var.project_name}-${var.environment}"
}
```

### Resource Organisation
```hcl
# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}
```

## Testing Requirements

Modern Terraform modules should use Terraform's native testing framework introduced in Terraform 1.6.0+. This provides first-class testing support without external dependencies.

### Minimum Testing Requirements

Every Terraform module **must** include at least one test file to ensure basic functionality and prevent regressions.

#### Required Test Structure
```
tests/
└── defaults.tftest.hcl        # Basic module validation test
```

### Basic Test Implementation

#### Essential Test Coverage
```hcl
# tests/defaults.tftest.hcl
run "basic_validation" {
  command = plan

  variables {
    # Provide realistic test values
    environment  = "dev"
    project_name = "test-project"
  }

  # Test that module creates resources
  assert {
    condition     = length(terraform.planned_values.root_module.resources) > 0
    error_message = "Module should plan to create at least one resource"
  }

  # Test variable validation
  assert {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be valid"
  }
}
```

### Test Execution Commands

```bash
# Run all tests
terraform test

# Run with verbose output
terraform test -verbose
```

### CI/CD Integration

The GitHub Actions pipeline **will fail** if:
- No `.tftest.hcl` files exist in the `tests/` directory
- Any test fails
- Terraform syntax is invalid

This ensures modules are properly tested before deployment.

### Expanding Tests

As you develop your module, consider adding:

#### Additional Test Scenarios
- **Edge Cases**: Test boundary conditions
- **Integration Tests**: Use `command = apply` for real resource testing
- **Error Conditions**: Test validation failures with `expect_failures`

#### Advanced Test Patterns
```hcl
# Test with different configurations
run "advanced_config" {
  command = plan

  variables {
    environment = "prod"
    enable_feature = true
    custom_config = {
      setting = "value"
    }
  }

  # Validate advanced configuration
  assert {
    condition     = var.enable_feature == true
    error_message = "Advanced features should be enabled"
  }
}

# Test validation failures
run "invalid_input" {
  command = plan

  variables {
    environment = "invalid"
  }

  expect_failures = [
    var.environment
  ]
}
```

### Testing Best Practices

#### ✅ Do
- Start with a simple basic test
- Use realistic test data
- Write clear error messages
- Test core module functionality
- Add tests when adding features

#### ❌ Don't
- Skip testing entirely
- Create overly complex initial tests
- Test trivial functionality
- Ignore test failures
- Hardcode sensitive values in tests

## Security Best Practices

### Sensitive Data Handling
- Mark sensitive variables appropriately
- Use random providers for passwords/keys
- Avoid hardcoded secrets
- Implement least privilege access

### Resource Security
- Enable encryption at rest and in transit
- Implement proper network segmentation
- Use security groups/NACLs appropriately
- Follow cloud provider security best practices

### Example Sensitive Variables
```hcl
variable "database_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

resource "random_password" "database" {
  count   = var.database_password == null ? 1 : 0
  length  = 16
  special = true
}
```

## Release Management

### Semantic Versioning
- Use semantic versioning (vX.Y.Z)
- Major version for breaking changes
- Minor version for new features
- Patch version for bug fixes

### CHANGELOG.md Format
```markdown
# Changelog

## [1.2.0] - 2024-01-15

### Added
- New variable for enabling VPC flow logs
- Support for additional availability zones

### Changed
- Updated AWS provider requirement to >= 4.0

### Fixed
- Fixed issue with subnet CIDR calculation

## [1.1.0] - 2023-12-01
...
```

### Git Tagging Strategy
```bash
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0
```

## Examples and Usage

### Basic Example
```hcl
# examples/basic/main.tf
module "vpc" {
  source = "../../"

  environment     = "dev"
  project_name    = "myproject"
  vpc_cidr        = "10.0.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b"]

  tags = {
    Owner = "platform-team"
  }
}
```

### Advanced Example
```hcl
# examples/advanced/main.tf
module "vpc" {
  source = "../../"

  environment     = "prod"
  project_name    = "myproject"
  vpc_cidr        = "10.0.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]

  enable_nat_gateway = true
  single_nat_gateway = false
  enable_vpn_gateway = true
  enable_flow_logs   = true

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]

  tags = {
    Owner       = "platform-team"
    CostCentre  = "engineering"
  }
}
```

## Validation and CI/CD

### Pre-commit Hooks
```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.5
    hooks:
      - id: terraform_fmt
      - id: terraform_docs
      - id: terraform_tflint
      - id: terraform_validate
      - id: terraform_checkov
```

### GitHub Actions Workflow
```yaml
# .github/workflows/terraform.yml
name: Terraform

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.5.0

    - name: Terraform Format
      run: terraform fmt -check -recursive

    - name: Terraform Init
      run: terraform init

    - name: Terraform Validate
      run: terraform validate

    - name: Run TFLint
      uses: terraform-linters/setup-tflint@v3
      with:
        tflint_version: v0.48.0

    - name: TFLint
      run: tflint --recursive

    - name: Run Checkov
      uses: bridgecrewio/checkov-action@master
      with:
        directory: .
        framework: terraform
```

### TFLint Configuration
```hcl
# .tflint.hcl
plugin "aws" {
  enabled = true
  version = "0.24.1"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}
```

## Quality Checklist

Before publishing a module, ensure:

- [ ] All files follow the standard structure
- [ ] Code is properly formatted (`terraform fmt`)
- [ ] All variables have descriptions and appropriate types
- [ ] All outputs have descriptions
- [ ] Examples are provided and tested
- [ ] Documentation is complete and auto-generated
- [ ] Tests are implemented and passing
- [ ] Security best practices are followed
- [ ] Semantic versioning is used
- [ ] CHANGELOG.md is updated
- [ ] CI/CD pipeline is configured
- [ ] Pre-commit hooks are set up

## Additional Resources

- [Terraform Module Registry](https://registry.terraform.io/)
- [HashiCorp Module Standards](https://www.terraform.io/docs/modules/index.html)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [terraform-docs](https://terraform-docs.io/)
- [TFLint](https://github.com/terraform-linters/tflint)
- [Checkov](https://www.checkov.io/)
- [Terratest](https://terratest.gruntwork.io/)

---

## Contributing

When contributing to this module:

1. Fork the repository
2. Create a feature branch
3. Make your changes following these guidelines
4. Run tests and validation
5. Update documentation
6. Submit a pull request

## Support

For questions or issues, please:
- Check existing GitHub issues
- Create a new issue with detailed information
- Follow the issue template provided
