#!/bin/bash

# Terraform Module Setup Script
# This script helps set up the development environment for the Terraform module

set -e

echo "🚀 Setting up Terraform Module Development Environment..."

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install pre-commit if not present
install_precommit() {
    if ! command_exists pre-commit; then
        echo "📦 Installing pre-commit..."
        if command_exists pip3; then
            pip3 install pre-commit
        elif command_exists pip; then
            pip install pre-commit
        else
            echo "❌ Error: pip is required to install pre-commit"
            exit 1
        fi
    else
        echo "✅ pre-commit is already installed"
    fi
}

# Function to check and report tool status
check_tool() {
    local tool=$1
    local install_url=$2

    if command_exists "$tool"; then
        echo "✅ $tool is installed"
        return 0
    else
        echo "❌ $tool is not installed. Install from: $install_url"
        return 1
    fi
}

# Check required tools
echo "🔍 Checking required tools..."

check_tool "terraform" "https://www.terraform.io/downloads.html"
check_tool "terraform-docs" "https://terraform-docs.io/user-guide/installation/"
check_tool "tflint" "https://github.com/terraform-linters/tflint"
check_tool "checkov" "https://www.checkov.io/2.Basics/Installing%20Checkov.html"
check_tool "tfsec" "https://aquasecurity.github.io/tfsec/latest/getting-started/installation/"

# Install and setup pre-commit
install_precommit

# Setup pre-commit hooks
if [ -f ".pre-commit-config.yaml" ]; then
    echo "🔧 Setting up pre-commit hooks..."
    pre-commit install
    echo "✅ Pre-commit hooks installed"
else
    echo "❌ .pre-commit-config.yaml not found"
fi

# Initialize TFLint
if command_exists tflint && [ -f ".tflint.hcl" ]; then
    echo "🔧 Initializing TFLint..."
    tflint --init
    echo "✅ TFLint initialized"
fi

# Validate Terraform configuration
if command_exists terraform; then
    echo "🔧 Validating Terraform configuration..."
    terraform fmt -check -recursive || {
        echo "⚠️  Formatting issues found. Running terraform fmt..."
        terraform fmt -recursive
    }

    terraform init -backend=false
    terraform validate
    echo "✅ Terraform configuration is valid"
fi

# Run initial checks
echo "🧪 Running initial validation..."

if command_exists tflint; then
    echo "Running TFLint..."
    tflint --recursive
fi

if command_exists checkov; then
    echo "Running Checkov..."
    checkov -d . --framework terraform --quiet --compact
fi

if command_exists tfsec; then
    echo "Running tfsec..."
    tfsec . --format lovely --no-colour
fi

# Run Terraform tests if available
if command_exists terraform && [ -d "tests" ] && [ "$(find tests -name "*.tftest.hcl" 2>/dev/null | wc -l)" -gt 0 ]; then
    echo "🧪 Running Terraform tests..."
    terraform test
    echo "✅ Terraform tests completed"
else
    echo "⚠️  No Terraform tests found in tests/ directory"
    echo "    Add at least one .tftest.hcl file to ensure module quality"
fi

echo ""
echo "🎉 Setup complete! Your Terraform module development environment is ready."
echo ""
echo "📋 Next steps:"
echo "1. Replace the example resources in main.tf with your actual infrastructure"
echo "2. Update variables.tf with your module's input variables"
echo "3. Update outputs.tf with your module's outputs"
echo "4. Update the README.md with your module's documentation"
echo "5. Add working examples in the examples/ directory"
echo "6. Run 'terraform-docs .' to generate documentation"
echo "7. Test your module with the provided examples"
echo "8. Add comprehensive tests in the tests/ directory"
echo "9. Run 'terraform test' to validate your module behaviour"
echo ""
echo "🧪 Testing Commands:"
echo "- 'terraform test' - Run all Terraform tests"
echo "- 'terraform test -verbose' - Run tests with detailed output"
echo "- Add tests in tests/ directory with .tftest.hcl extension"
echo ""
echo "📖 See TERRAFORM_MODULE_STANDARDS.md for detailed guidelines."
echo "🔧 Run 'pre-commit run --all-files' to validate all files."
