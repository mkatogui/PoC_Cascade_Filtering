# GitHub Actions Workflow Documentation

This document explains the key components of the CI/CD workflow configuration in `.github/workflows/r-ci-cd.yml`.

## Overview

The GitHub Actions workflow automates testing and deployment of the BasicCascadeApp to shinyapps.io. It's designed to handle common issues like compiler warnings and package installation problems in CI environments.

## Key Features

### 1. CRAN Mirror Configuration

All R script executions explicitly set a CRAN mirror to ensure reliable package installation:

```r
options(repos = c(CRAN = "https://cloud.r-project.org"))
```

This prevents the "trying to use CRAN without setting a mirror" error that commonly occurs in CI environments.

### 2. Git Configuration

The workflow configures Git properly for the CI environment:

```yaml
- name: Set up Git configuration
  run: |
    git config --global --add safe.directory "$GITHUB_WORKSPACE"
    git config --global user.email "actions@github.com"
    git config --global user.name "GitHub Actions"
```

This helps avoid Git-related issues during checkout and potential deployment steps.

### 3. Warning Handling

The workflow handles R compiler warnings in several ways:

- Setting `options(warn = 1)` to print warnings without stopping execution
- Using `suppressWarnings()` around package loading
- Using `tryCatch()` to capture and report warnings without failing the workflow
- Setting environment variables like `R_TESTS=""` to prevent certain R test warnings

### 4. Dependency Verification

After installing packages, the workflow verifies that all required packages were actually installed:

```r
installed_packages <- rownames(installed.packages())
required_packages <- c("testthat", "shiny", "shinyFeedback", "shinyjs", "tibble")
missing_packages <- setdiff(required_packages, installed_packages)

if (length(missing_packages) > 0) {
  stop("Failed to install: ", paste(missing_packages, collapse = ", "))
}
```

### 5. Diagnostic Information

The workflow includes diagnostic information to help troubleshoot issues:

- Printing R session info
- Listing files to be deployed
- Providing detailed error messages

## Troubleshooting

If the workflow is still failing:

1. Check if all required packages are being installed
2. Ensure proper CRAN mirror configuration
3. Look for R error messages in the workflow logs
4. Verify that the deployed app files include all necessary dependencies

## References

- [GitHub Actions for R](https://github.com/r-lib/actions)
- [rsconnect Package Documentation](https://rstudio.github.io/rsconnect/)
