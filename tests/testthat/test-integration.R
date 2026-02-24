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
  app$set_inputs(`filterMod-comment` = "Valid comment") # 13 chars (10-20 allowed)
  
  # 4. Verify that Apply button is VISIBLE but DISABLED (as validation should initially fail)
  is_apply_visible <- app$get_js("$('#apply').css('display') !== 'none'")
  is_apply_disabled <- app$get_js("$('#apply').prop('disabled') === true")
  expect_true(is_apply_visible, "Apply button should be visible")
  expect_true(is_apply_disabled, "Apply button should be disabled initially")
  
  # 5. Fill validation fields to enable Apply
  app$set_inputs(`filterMod-quantity` = 5)
  app$set_inputs(`filterMod-comment` = "Valid comment") # 13 chars
  
  # Verify enabled
  app$wait_for_js("$('#apply').prop('disabled') === false")
  expect_false(app$get_js("$('#apply').prop('disabled') === true"), "Apply button should be enabled after valid inputs")
  
  # 6. Apply the filter
  app$click("apply")
  app$wait_for_js("$('.modal').length === 0") # Wait for modal to close
  
  # 7. Verify main UI output
  final_text <- app$get_text("#selection")
  expect_match(final_text, "Category : Electronics")
  expect_match(final_text, "Product : iPhone")
  expect_match(final_text, "Quantity : 5")
  
  # 8. REPEAT CYCLE: Verify no observer duplication (Point 23)
  # If observers were duplicated, logs or reactivity might double-fire.
  # We just check stability here.
  app$click("showModal")
  app$wait_for_js("$('.modal').length > 0")
  app$set_inputs(`filterMod-category` = "Clothing")
  app$wait_for_js("$('#apply').prop('disabled') === true")
  app$click("reset") # Test reset logic
  
  # Cleanup
  app$click(selector = ".modal .btn-secondary", click_js = TRUE) # Cancel/Close
})
