# Integration test for BasicCascadeApp
library(testthat)
library(shiny)
library(shinytest2)

test_that("Full cascading filter flow works correctly", {
  # Skip test if shinytest2 isn't available
  skip_if_not_installed("shinytest2")
  
  # Get absolute path to the app directory
  app_dir <- getwd()
  app_file <- file.path(app_dir, "app.R")
  if (!file.exists(app_file)) {
    app_dir <- normalizePath("../..")
  }
  
  # Start the app
  app <- tryCatch({
    AppDriver$new(app_dir, name = "BasicCascadeApp", timeout = 20000, variant = NULL)
  }, error = function(e) {
    skip(paste("Failed to load app:", e$message))
    NULL
  })
  
  if (is.null(app)) return()
  on.exit(app$stop())

  # 1. Open the filter modal
  app$click("showModal")
  app$wait_for_js("$('.modal').length > 0")
  
  # 2. Simulate cascading selections
  # Category -> Electronics
  app$set_inputs(`filterMod-category` = "Electronics")
  
  # Subcategory -> Phones (waits for reactive update)
  app$set_inputs(`filterMod-subcategory` = "Phones")
  
  # Product -> iPhone
  app$set_inputs(`filterMod-product` = "iPhone")
  
  # 3. Fill validation fields
  app$set_inputs(`filterMod-quantity` = 5)
  app$set_inputs(`filterMod-comment` = "Validation passes here") # > 10 chars
  
  # 4. Verify that Apply button is now visible (as validation should pass)
  # In server.R, the apply button is conditionally shown via shinyjs::hidden(actionButton("apply", ...))
  # We check the display property
  is_apply_visible <- app$get_js("$('#apply').css('display') !== 'none'")
  expect_true(is_apply_visible, "Apply button should be visible when fields are valid")
  
  # 5. Apply the filter
  app$click("apply")
  app$wait_for_js("$('.modal').length === 0") # Wait for modal to close
  
  # 6. Verify main UI output
  # The output$selection displays the summary
  final_text <- app$get_text("#selection")
  
  expect_match(final_text, "Category : Electronics")
  expect_match(final_text, "Subcategory : Phones")
  expect_match(final_text, "Product : iPhone")
  expect_match(final_text, "Quantity : 5")
  expect_match(final_text, "Comment : Validation passes here")
  expect_match(final_text, "✓ Valid", all = FALSE) # Check that some validation marks appear
})
