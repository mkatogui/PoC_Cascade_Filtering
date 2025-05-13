# Setup test environment options to handle compiler warnings
# This will be run before tests to set appropriate options

# Set CRAN mirror for package installations
options(repos = c(CRAN = "https://cloud.r-project.org"))

options(warn = 1)  # Print warnings as they occur but don't convert to errors

# Suppress specific types of warnings that might come from dependencies
suppressWarnings({
  library(shiny)
  library(shinyFeedback)
  library(shinyjs)
  library(testthat)
})

# Set environment variables that might help with CI testing
Sys.setenv("R_TESTS" = "")
Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "false")
