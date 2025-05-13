
# BasicCascadeApp Test Suite
#
# To run all tests:
#   library(testthat)
#   testthat::test_dir("tests/testthat")
#
# This test suite contains unit tests for validation functions and
# integration tests for UI interaction.
# Used by both local test runs and CI/CD pipeline.

# Set CRAN mirror for package installations
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Load required libraries
library(testthat)

# Configure test environment
options(warn = 1)  # Print warnings as they occur but don't convert to errors
Sys.setenv("R_TESTS" = "")
Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "false")

# Suppress compiler warnings from dependencies
suppressWarnings({
  library(shiny)
  library(shinyFeedback)
  library(shinyjs)
})

# Run test directory with custom reporter that ignores certain warnings
test_dir("tests/testthat", reporter = "summary")

