# Project-wide .Rprofile for handling compiler warnings in the BasicCascadeApp
# This file is loaded when R starts in this project

# Set global warning level
options(warn = 1)  # Print warnings as they occur but don't convert to errors

# Environment variables for testing
if (Sys.getenv("TESTTHAT") == "true" || basename(getwd()) == "testthat") {
  Sys.setenv("R_TESTS" = "")
  Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "false")
  
  # Helper function to load packages with warnings suppressed
  suppressPackageWarnings <- function(...) {
    packages <- c(...)
    for (pkg in packages) {
      suppressWarnings(require(pkg, character.only = TRUE))
    }
  }
  
  # Suppress warnings when loading packages commonly used in the app
  suppressPackageWarnings("shiny", "shinyFeedback", "shinyjs", "tibble")
}

# Make sure testthat knows we have a custom reporter
if (requireNamespace("testthat", quietly = TRUE)) {
  options(testthat.summary.max_reports = 10)  # Limit number of warning reports
}
