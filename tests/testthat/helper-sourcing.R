# Helper to source the application environment for tests
# This ensures that constants, configuration, and functions are available
# to all test files in tests/testthat/

# Source the main init script
source("../../R/init.R")

# Ensure we are in a testing state if needed
options(poc.test_mode = TRUE)
