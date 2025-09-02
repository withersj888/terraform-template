# Terraform Module Tests

This directory contains tests for the Terraform module using Terraform's native testing framework (available in Terraform 1.6.0+).

## Test Files

| File | Purpose | Description |
|------|---------|-------------|
| `defaults.tftest.hcl` | Basic module validation | Tests core module functionality with standard inputs |

## Running Tests

```powershell
# Run all tests
terraform test

# Run with detailed output
terraform test -verbose
```

## Adding Tests

When customising this module template, add appropriate tests for your specific functionality:

1. **Create test files** with `.tftest.hcl` extension
2. **Use descriptive test names** that explain what is being validated
3. **Test both positive and negative scenarios**
4. **Include meaningful error messages** in assertions

## Example Test Structure

```hcl
run "test_name" {
  command = plan # or apply for integration tests

  variables {
    # Define test inputs
  }

  assert {
    condition     = # condition to test
    error_message = "Clear description of what failed"
  }
}
```

## CI/CD Integration

Tests are automatically executed in GitHub Actions. The CI pipeline will fail if:
- No test files exist in the `tests/` directory
- Any test fails
- Terraform syntax is invalid

This ensures your module is properly tested before deployment.
