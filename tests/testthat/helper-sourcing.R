# Helper to source the application environment for tests
# This ensures that constants, configuration, and functions are available
# to all test files in tests/testthat/

# Source the main init script from the project root (Point 26)
# We set the working directory temporarily so init.R can find R/config.R etc.
local({
  old_wd <- getwd()
  on.exit(setwd(old_wd))
  setwd(normalizePath("../.."))
  source("R/init.R", local = FALSE)
})

# Ensure we are in a testing state if needed
options(poc.test_mode = TRUE)
