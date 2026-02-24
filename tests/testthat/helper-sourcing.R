# Helper to source the application environment for tests
# This ensures that constants, configuration, and functions are available
# to all test files in tests/testthat/

# Source the main init script from the project root
# We set the working directory temporarily so init.R can find R/config.R etc.
local({
  old_wd <- getwd()
  on.exit(setwd(old_wd))
  setwd(normalizePath("../.."))
  # Use local = FALSE to inject into the environment where helper is sourced
  source("R/init.R", local = FALSE)
})

# Ensure we are in a testing state
options(poc.test_mode = TRUE)
