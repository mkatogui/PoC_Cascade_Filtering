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

### 2. System Dependencies

The workflow installs necessary system dependencies for building R packages with C/C++ code:

```yaml
- name: Install system dependencies
  run: |
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
      libcurl4-openssl-dev \
      libssl-dev \
      libxml2-dev 
      # other dependencies...
```

This ensures packages like `curl` can be built from source when necessary.

### 3. Package Caching

To speed up builds, the workflow caches R packages:

```yaml
- name: Cache R packages
  uses: actions/cache@v3
  with:
    path: ${{ env.R_LIBS_USER }}
    key: ${{ runner.os }}-r-${{ hashFiles('**/DESCRIPTION') }}
    restore-keys: ${{ runner.os }}-r-
```

### 4. Git Configuration

The workflow configures Git properly for the CI environment:

```yaml
- name: Set up Git configuration
  run: |
    git config --global --add safe.directory "$GITHUB_WORKSPACE"
    git config --global user.email "actions@github.com"
    git config --global user.name "GitHub Actions"
```

This helps avoid Git-related issues during checkout and potential deployment steps.

### 5. Warning Handling

The workflow handles R compiler warnings in several ways:

- Setting `options(warn = 1)` to print warnings without stopping execution
- Using `suppressWarnings()` around package loading
- Using `tryCatch()` to capture and report warnings without failing the workflow
- Setting environment variables like `R_TESTS=""` to prevent certain R test warnings

### 6. Force Update for Deployment

The deployment process uses the `forceUpdate = TRUE` parameter to update existing applications:

```r
rsconnect::deployApp(
  appDir = ".",
  appName = Sys.getenv("APP_NAME"),
  appFiles = c("app.R", "R/"),
  forceUpdate = TRUE,  # Force update of existing app
  launch.browser = FALSE,
  logLevel = "verbose"
)
```

This allows the workflow to update an existing app instead of failing when an app with the same name already exists.

### 7. Dependency Verification

After installing packages, the workflow verifies that all required packages were actually installed:

```r
installed_packages <- rownames(installed.packages())
required_packages <- c("testthat", "shiny", "shinyFeedback", "shinyjs", "tibble")
missing_packages <- setdiff(required_packages, installed_packages)

if (length(missing_packages) > 0) {
  stop("Failed to install: ", paste(missing_packages, collapse = ", "))
}
```

### 5. Deployment Strategy

The workflow uses a robust deployment strategy for shinyapps.io:

1. **Package installation verification**: Ensures all required packages are installed before attempting deployment
2. **Fallback deployment strategy**: If the initial deployment fails, attempts a simplified deployment approach
3. **Detailed logging**: Uses verbose logging to help diagnose deployment issues
4. **Configuration file**: Uses `shinyapps.yml` to provide consistent deployment settings

#### Package Installation

Package installation is handled carefully:
```r
# Install rsconnect separately to ensure it succeeds
install.packages("rsconnect")

# Verify installation
if (!requireNamespace("rsconnect", quietly = TRUE)) {
  stop("Failed to install rsconnect package")
}
```

### 6. Diagnostic Information

The workflow includes diagnostic information to help troubleshoot issues:

If the workflow is still failing:

1. Check if all required packages are being installed
2. Ensure proper CRAN mirror configuration
3. Look for R error messages in the workflow logs
4. Verify that the deployed app files include all necessary dependencies

## References

- [GitHub Actions for R](https://github.com/r-lib/actions)
- [rsconnect Package Documentation](https://rstudio.github.io/rsconnect/)
