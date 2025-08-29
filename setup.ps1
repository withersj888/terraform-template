<#
.SYNOPSIS
    Terraform Module Setup Script for Windows/PowerShell environments.

.DESCRIPTION
    This script helps set up the development environment for the Terraform module,
    installing and configuring necessary tools for development and validation.

.PARAMETER SkipToolCheck
    Skip the tool availability checks and proceed with setup.

.PARAMETER Verbose
    Enable verbose output for debugging.

.EXAMPLE
    .\setup.ps1
    Sets up the Terraform module development environment.

.EXAMPLE
    .\setup.ps1 -SkipToolCheck
    Sets up the environment without checking tool availability.

.INPUTS
    None. You cannot pipe objects to this script.

.OUTPUTS
    Console output showing setup progress and results.

.NOTES
    Author: Terraform Module Template
    Version: 1.0.0
    Requires: PowerShell 7.0+, Terraform 1.6.0+
#>

[CmdletBinding()]
[OutputType([void])]
param(
    [Parameter()]
    [switch]$SkipToolCheck,

    [Parameter()]
    [switch]$VerboseOutput
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Set console encoding for emoji support
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "🚀 Setting up Terraform Module Development Environment..." -ForegroundColor Blue

#region Helper Functions

<#
.SYNOPSIS
    Checks if a command/tool is available in the system PATH.
#>
function Test-CommandExists {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$Command
    )

    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

<#
.SYNOPSIS
    Installs pre-commit using pip if not already present.
#>
function Install-PreCommit {
    [CmdletBinding()]
    param()

    if (-not (Test-CommandExists 'pre-commit')) {
        Write-Host "📦 Installing pre-commit..." -ForegroundColor Yellow

        if (Test-CommandExists 'pip') {
            try {
                pip install pre-commit
                Write-Host "✅ pre-commit installed successfully" -ForegroundColor Green
            }
            catch {
                Write-Warning "❌ Failed to install pre-commit: $($_.Exception.Message)"
                Write-Host "Please install pre-commit manually: https://pre-commit.com/" -ForegroundColor Yellow
            }
        }
        else {
            Write-Warning "❌ pip is not available. Please install Python and pip first."
            Write-Host "Then run: pip install pre-commit" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "✅ pre-commit is already installed" -ForegroundColor Green
    }
}

<#
.SYNOPSIS
    Checks if a tool is installed and reports status.
#>
function Test-ToolAvailability {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$Tool,

        [Parameter(Mandatory)]
        [string]$InstallUrl
    )

    if (Test-CommandExists $Tool) {
        Write-Host "✅ $Tool is installed" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "❌ $Tool is not installed. Install from: $InstallUrl" -ForegroundColor Red
        return $false
    }
}

#endregion

#region Main Setup Logic

try {
    # Check required tools unless skipped
    if (-not $SkipToolCheck) {
        Write-Host "🔍 Checking required tools..." -ForegroundColor Blue

        $tools = @{
            'terraform'      = 'https://www.terraform.io/downloads.html'
            'terraform-docs' = 'https://terraform-docs.io/user-guide/installation/'
            'tflint'         = 'https://github.com/terraform-linters/tflint'
            'checkov'        = 'https://www.checkov.io/2.Basics/Installing%20Checkov.html'
            'tfsec'          = 'https://aquasecurity.github.io/tfsec/latest/getting-started/installation/'
        }

        $missingTools = @()
        foreach ($tool in $tools.GetEnumerator()) {
            if (-not (Test-ToolAvailability -Tool $tool.Key -InstallUrl $tool.Value)) {
                $missingTools += $tool.Key
            }
        }

        if ($missingTools.Count -gt 0) {
            Write-Warning "Some tools are missing. Please install them before proceeding."
            Write-Host "Missing tools: $($missingTools -join ', ')" -ForegroundColor Yellow
        }
    }

    # Install and setup pre-commit
    Install-PreCommit

    # Setup pre-commit hooks
    if (Test-Path '.pre-commit-config.yaml') {
        Write-Host "🔧 Setting up pre-commit hooks..." -ForegroundColor Blue
        try {
            pre-commit install
            Write-Host "✅ Pre-commit hooks installed" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to install pre-commit hooks: $($_.Exception.Message)"
        }
    }
    else {
        Write-Warning "❌ .pre-commit-config.yaml not found"
    }

    # Initialize TFLint
    if ((Test-CommandExists 'tflint') -and (Test-Path '.tflint.hcl')) {
        Write-Host "🔧 Initializing TFLint..." -ForegroundColor Blue
        try {
            tflint --init
            Write-Host "✅ TFLint initialized" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to initialize TFLint: $($_.Exception.Message)"
        }
    }

    # Validate Terraform configuration
    if (Test-CommandExists 'terraform') {
        Write-Host "🔧 Validating Terraform configuration..." -ForegroundColor Blue

        # Check formatting
        $formatResult = terraform fmt -check -recursive
        if ($LASTEXITCODE -ne 0) {
            Write-Host "⚠️  Formatting issues found. Running terraform fmt..." -ForegroundColor Yellow
            terraform fmt -recursive
        }

        # Initialize and validate
        terraform init -backend=false
        terraform validate
        Write-Host "✅ Terraform configuration is valid" -ForegroundColor Green
    }

    # Run initial checks
    Write-Host "🧪 Running initial validation..." -ForegroundColor Blue

    if (Test-CommandExists 'tflint') {
        Write-Host "Running TFLint..." -ForegroundColor Cyan
        try {
            tflint --recursive
        }
        catch {
            Write-Warning "TFLint found issues. Please review and fix them."
        }
    }

    if (Test-CommandExists 'checkov') {
        Write-Host "Running Checkov..." -ForegroundColor Cyan
        try {
            checkov -d . --framework terraform --quiet --compact
        }
        catch {
            Write-Warning "Checkov found issues. Please review and fix them."
        }
    }

    if (Test-CommandExists 'tfsec') {
        Write-Host "Running tfsec..." -ForegroundColor Cyan
        try {
            tfsec . --format lovely --no-colour
        }
        catch {
            Write-Warning "tfsec found issues. Please review and fix them."
        }
    }

    # Run Terraform tests if available
    if ((Test-CommandExists 'terraform') -and (Test-Path 'tests') -and
        (@(Get-ChildItem -Path 'tests' -Filter '*.tftest.hcl' -ErrorAction SilentlyContinue).Count -gt 0)) {
        Write-Host "🧪 Running Terraform tests..." -ForegroundColor Blue
        try {
            terraform test
            Write-Host "✅ Terraform tests completed" -ForegroundColor Green
        }
        catch {
            Write-Warning "Some Terraform tests failed. Please review and fix them."
        }
    }
    else {
        Write-Host "⚠️  No Terraform tests found in tests/ directory" -ForegroundColor Yellow
        Write-Host "    Add at least one .tftest.hcl file to ensure module quality" -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "🎉 Setup complete! Your Terraform module development environment is ready." -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Blue
    Write-Host "1. Replace the example resources in main.tf with your actual infrastructure" -ForegroundColor White
    Write-Host "2. Update variables.tf with your module's input variables" -ForegroundColor White
    Write-Host "3. Update outputs.tf with your module's outputs" -ForegroundColor White
    Write-Host "4. Update the README.md with your module's documentation" -ForegroundColor White
    Write-Host "5. Add working examples in the examples/ directory" -ForegroundColor White
    Write-Host "6. Run 'terraform-docs .' to generate documentation" -ForegroundColor White
    Write-Host "7. Test your module with the provided examples" -ForegroundColor White
    Write-Host "8. Add comprehensive tests in the tests/ directory" -ForegroundColor White
    Write-Host "9. Run 'terraform test' to validate your module behaviour" -ForegroundColor White
    Write-Host ""
    Write-Host "🧪 Testing Commands:" -ForegroundColor Blue
    Write-Host "- 'terraform test' - Run all Terraform tests" -ForegroundColor White
    Write-Host "- 'terraform test -verbose' - Run tests with detailed output" -ForegroundColor White
    Write-Host "- Add tests in tests/ directory with .tftest.hcl extension" -ForegroundColor White
    Write-Host ""
    Write-Host "📖 See TERRAFORM_MODULE_STANDARDS.md for detailed guidelines." -ForegroundColor Cyan
    Write-Host "🔧 Run 'pre-commit run --all-files' to validate all files." -ForegroundColor Cyan
}
catch {
    Write-Error "Setup failed: $($_.Exception.Message)"
    exit 1
}

#endregion
