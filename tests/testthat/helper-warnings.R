# Helper function to suppress specific compiler warnings during tests
suppress_compiler_warnings <- function() {
  # Store original warning options
  old_warn <- getOption("warn")
  
  # Temporarily suppress all warnings during loading of libraries
  options(warn = -1)
  
  # Load libraries that may generate compiler warnings
  suppressWarnings({
    library(shiny)
    library(shinyFeedback)
    library(shinyjs)
    library(tibble)
  })
  
  # Restore warning level, but set to print without stopping
  options(warn = 1)
  
  # Set environment variables that help in test environments
  Sys.setenv("R_TESTS" = "")
  Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "false")
}

# Return a modified test reporter that filters specific warnings
custom_warning_filter <- function(reporter = "summary") {
  reporter_obj <- testthat::ProgressReporter$new()
  
  # Override the reporter's warning method to filter out specific warnings
  reporter_obj$warning <- function(condition) {
    # List of warning patterns to ignore
    ignored_patterns <- c(
      "Overloaded virtual method",
      "is deprecated",
      "is superseded",
      "sass compilation"
    )
    
    # Check if this warning should be ignored
    for (pattern in ignored_patterns) {
      if (grepl(pattern, condition$message, ignore.case = TRUE)) {
        # Skip this warning
        return(invisible())
      }
    }
    
    # For other warnings, use the default behavior
    NextMethod()
  }
  
  return(reporter_obj)
}

# Set up the test environment to handle warnings properly
setup_test_environment <- function() {
  # Call the suppress_compiler_warnings function
  suppress_compiler_warnings()
  
  # Setup specific filters for common R package warnings
  withr::local_options(list(
    shiny.suppressMissingContextError = TRUE,
    shiny.test.SHINY_TESTTHAT = TRUE
  ))
}
