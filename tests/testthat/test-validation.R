# Unit tests for validation logic
library(testthat)
# Dependencies are loaded via helper-sourcing.R -> init.R

test_that("is_valid_category handles edge cases correctly", {
  expect_true(is_valid_category("Electronics"))
  expect_false(is_valid_category(""))
  expect_false(is_valid_category(NA_character_))
  expect_false(is_valid_category(NULL))
  expect_false(is_valid_category(c("A", "B")))
  expect_false(is_valid_category(123))
})

test_that("is_valid_quantity handles edge cases strictly", {
  expect_true(is_valid_quantity(5))
  expect_true(is_valid_quantity(1))

  # Failures
  expect_false(is_valid_quantity(0))
  expect_false(is_valid_quantity(-1))
  expect_false(is_valid_quantity(5.5))
  expect_false(is_valid_quantity(NA_real_))
  expect_false(is_valid_quantity(Inf))
  expect_false(is_valid_quantity("5"))
  expect_false(is_valid_quantity(c(1, 2)))
})

test_that("is_valid_comment respects constants and existence", {
  # Boundary values from constants.R (10-20)
  expect_true(is_valid_comment("ValidCommentHere")) # 16 chars
  expect_true(is_valid_comment("1234567890")) # 10 chars
  expect_true(is_valid_comment("12345678901234567890")) # 20 chars

  # Failures
  expect_false(is_valid_comment("Too short")) # 9 chars
  expect_false(is_valid_comment("This comment is way too long for the system"))
  expect_false(is_valid_comment(""))
  expect_false(is_valid_comment(NA_character_))
})

test_that("is_valid_order_date respects boundary conditions", {
  # 2023-01-01 to 2026-12-31
  expect_true(is_valid_order_date(as.Date("2023-01-01")))
  expect_true(is_valid_order_date(as.Date("2024-06-01")))
  expect_true(is_valid_order_date(as.Date("2026-12-31")))

  # Failures
  expect_false(is_valid_order_date(as.Date("2022-12-31")))
  expect_false(is_valid_order_date(as.Date("2027-01-01")))
  expect_false(is_valid_order_date(NA))
  expect_false(is_valid_order_date("2024-01-01"))
})

test_that("all_fields_valid is resilient to malformed input objects", {
  # Mock valid input
  valid_input <- list(
    category = "Electronics",
    subcategory = "Phones",
    product = "iPhone",
    quantity = 5,
    comment = "Valid comment here",
    orderDate = as.Date("2024-01-01")
  )
  expect_true(all_fields_valid(valid_input))

  # Mock invalid inputs
  expect_false(all_fields_valid(list())) # Empty
  expect_false(all_fields_valid(list(category = "Electronics"))) # Partial
})
