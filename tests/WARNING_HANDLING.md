# Handling Compiler Warnings in Shiny Tests

This document explains the approach used in this project to handle compiler warnings that may appear during testing, especially those related to Sass compilation in Shiny packages.

## Background

When testing Shiny applications, you may encounter compiler warnings related to:
- C++ code compilation in package dependencies
- Sass compilation in Shiny and related packages
- Deprecated functions or features

These warnings are generally not issues with your code but rather with dependencies or the R environment. However, they can make test output harder to read and may cause CI pipelines to fail if warnings are treated as errors.

## Solution Components

### 1. Project-wide Settings (.Rprofile)

The `.Rprofile` file in the project root contains settings that apply to all R sessions in this project:

```r
options(warn = 1)  # Print warnings as they occur but don't convert to errors
```

This ensures warnings are printed but don't abort execution.

### 2. Helper Functions for Tests

The `tests/testthat/helper-warnings.R` file contains functions to:
- Suppress warnings during package loading
- Provide custom test reporters that filter specific warnings

### 3. CI/CD Configuration

The GitHub Actions workflow `.github/workflows/r-ci-cd.yml` is configured to:
- Set the appropriate warning level
- Suppress package loading warnings
- Use tryCatch to handle warnings without failing the pipeline
- Carefully handle diagnostic outputs for better troubleshooting

### Handling Pipeline Failures

If tests are still failing in CI despite these measures:

1. Check the GitHub Actions logs for specific error messages
2. Look for warning messages that might be upgraded to errors in the CI environment
3. Consider adding specific warning suppressions for problematic packages
4. Ensure all dependencies are properly installed in the CI environment

## Using This Approach in Your Tests

When writing new tests, you can use the following pattern:

```r
test_that("My test description", {
  # Load packages with warning suppression
  suppressWarnings({
    library(shiny)
    # other packages...
  })
  
  # Your test code here
  expect_true(TRUE)
})
```

## Modifying Warning Handling

If you need to adjust how warnings are handled:

1. Edit `tests/testthat/helper-warnings.R` to add or modify suppression logic
2. Update `.Rprofile` for project-wide settings
3. Modify `.github/workflows/r-ci-cd.yml` for CI/CD-specific settings

## References

- [testthat Documentation](https://testthat.r-lib.org/)
- [R Warning Handling](https://stat.ethz.ch/R-manual/R-devel/library/base/html/warning.html)
- [GitHub Actions for R](https://github.com/r-lib/actions)
