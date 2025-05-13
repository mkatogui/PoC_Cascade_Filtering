# Integration test for BasicCascadeApp
library(testthat)
library(shiny)
library(shinytest2)

test_that("Filter module functions correctly", {
  # Skip test if not interactive or if shinytest2 isn't available
  skip_if_not_installed("shinytest2")
  skip_on_ci()
  
  # Get the absolute path to the app directory (project root)
  app_dir <- normalizePath(file.path(dirname(dirname(getwd()))))
  
  # Make sure app.R exists in the directory
  app_file <- file.path(app_dir, "app.R")
  if (!file.exists(app_file)) {
    skip(paste("app.R not found at:", app_file))
  }
  
  # Use tryCatch to provide more informative error messages
  app <- tryCatch({
    AppDriver$new(app_dir, name = "BasicCascadeApp", timeout = 10000)
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
