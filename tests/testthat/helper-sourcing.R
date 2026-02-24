# Helper to source the application environment for tests
# This ensures that constants, configuration, and functions are available
# to all test files in tests/testthat/

# Source the main init script from the project root so that
# init.R's relative source() calls (e.g. source("R/config.R")) resolve correctly.
old_wd <- setwd("../..")
tryCatch(
  source("R/init.R"),
  finally = setwd(old_wd)
)

# Ensure we are in a testing state if needed
options(poc.test_mode = TRUE)
