library(testthat)

test_that("is_valid_category handles edge cases correctly", {
  expect_true(is_valid_category("Electronics"))
  expect_false(is_valid_category(""))
  expect_false(is_valid_category(NULL))
  expect_false(is_valid_category(NA_character_))
  expect_false(is_valid_category(c("A", "B"))) # Vector check
  expect_false(is_valid_category(123))           # Type check
})

test_that("is_valid_quantity handles edge cases strictly", {
  expect_true(is_valid_quantity(5))
  expect_true(is_valid_quantity(1.0))
  expect_false(is_valid_quantity(0))
  expect_false(is_valid_quantity(-1))
  expect_false(is_valid_quantity(1.5))           # Non-integer
  expect_false(is_valid_quantity(NA_real_))
  expect_false(is_valid_quantity(Inf))
  expect_false(is_valid_quantity(NULL))
  expect_false(is_valid_quantity(c(1, 2)))       # Vector check
})

test_that("is_valid_comment respects constants and guards", {
  # Assuming COMMENT_MIN_LENGTH=10, COMMENT_MAX_LENGTH=20
  expect_true(is_valid_comment("ValidCommentHere")) # 16 chars
  expect_false(is_valid_comment("Short"))           # < 10
  expect_false(is_valid_comment("ThisCommentIsDefinitelyTooLongToBeValid")) # > 20
  expect_false(is_valid_comment(NA_character_))
  expect_false(is_valid_comment(NULL))
  expect_false(is_valid_comment(""))
})

test_that("is_valid_order_date respects boundary constants", {
  # MIN=2023-01-01, MAX=2026-12-31
  expect_true(is_valid_order_date(as.Date("2023-01-01")))
  expect_true(is_valid_order_date(as.Date("2026-12-31")))
  expect_true(is_valid_order_date(as.Date("2024-06-15")))
  
  expect_false(is_valid_order_date(as.Date("2022-12-31"))) # Out of bounds
  expect_false(is_valid_order_date(as.Date("2027-01-01"))) # Out of bounds
  expect_false(is_valid_order_date("2024-01-01"))        # Wrong type
  expect_false(is_valid_order_date(NA))
  expect_false(is_valid_order_date(c(Sys.Date(), Sys.Date()))) # Vector
})

test_that("all_fields_valid is resilient to malformed inputs", {
  # Mock valid input list
  valid_input <- list(
    category = "Electronics",
    subcategory = "Phones",
    product = "iPhone",
    quantity = 5,
    comment = "Valid length comment",
    orderDate = as.Date("2024-01-01")
  )
  
  expect_true(all_fields_valid(valid_input))
  
  # Fail on any missing field
  invalid_input <- valid_input
  invalid_input$quantity <- NULL
  expect_false(all_fields_valid(invalid_input))
  
  # Fail on vector input
  invalid_vec <- valid_input
  invalid_vec$category <- c("A", "B")
  expect_false(all_fields_valid(invalid_vec))
})
