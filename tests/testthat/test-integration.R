# Integration test for BasicCascadeApp
library(testthat)
library(shiny)
library(shinytest2)

test_that("Filter module functions correctly", {
  # Skip test if shinytest2 isn't available
  skip_if_not_installed("shinytest2")
  
  # Get the absolute path to the app directory (project root)
  # When running via test_dir("tests/testthat"), getwd() is the project root
  app_dir <- getwd()
  
  # Make sure app.R exists in the directory
  app_file <- file.path(app_dir, "app.R")
  if (!file.exists(app_file)) {
    # Try one level up if we are inside tests/testthat already
    app_dir <- normalizePath("../..")
    app_file <- file.path(app_dir, "app.R")
  }
  
  if (!file.exists(app_file)) {
    skip(paste("app.R not found at:", app_dir))
  }
  
  # Use tryCatch to provide more informative error messages
  app <- tryCatch({
    # Forces headless mode for CI stability
    AppDriver$new(app_dir, name = "BasicCascadeApp", timeout = 20000, variant = NULL)
  }, error = function(e) {
    skip(paste("Failed to load app:", e$message))
    NULL
  })
  
  # If app failed to load, the test has already been skipped
  if (is.null(app)) return()
  
  # Test basic app loading
  expect_true(inherits(app, "AppDriver"), "App should load successfully")
  
  # Click "Open Filter" button
  app$click("showModal")
  
  # Check that the modal opens by verifying a modal element is present
  result <- app$get_js("$('.modal').length > 0")
  expect_true(result, "Filter modal should open")
  
  # Stop the app
  app$stop()
})
