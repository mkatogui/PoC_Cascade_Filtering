# Unit tests for validation functions
library(testthat)

# Load validation functions from the source file
# Using a relative path that works when running from the project root
source(file.path("..", "..", "R", "validation.R"))

# Category validation
test_that("Category validation works", {
  expect_true(is_valid_category("Electronics"))
  expect_false(is_valid_category(""))
  expect_false(is_valid_category(NULL))
})

# Subcategory validation
test_that("Subcategory validation works", {
  expect_true(is_valid_subcategory("Phones", "Electronics"))
  expect_false(is_valid_subcategory("Phones", "")) # Fails if parent category is empty
  expect_false(is_valid_subcategory("", "Electronics"))
  expect_false(is_valid_subcategory(NULL, "Electronics"))
})

# Product validation
test_that("Product validation works", {
  expect_true(is_valid_product("iPhone", "Phones", "Electronics"))
  expect_false(is_valid_product("iPhone", "", "Electronics")) # Fails if parent subcategory is empty
  expect_false(is_valid_product("", "Phones", "Electronics"))
  expect_false(is_valid_product(NULL, "Phones", "Electronics"))
})

# Quantity validation
test_that("Quantity validation works", {
  expect_true(is_valid_quantity(1))
  expect_true(is_valid_quantity(10))
  expect_false(is_valid_quantity(1.5)) # Must be integer
  expect_false(is_valid_quantity(0))
  expect_false(is_valid_quantity(-1))
  expect_false(is_valid_quantity(NA))
})

# Comment validation
test_that("is_valid_comment works", {
  expect_true(is_valid_comment("abcdefghij"))
  expect_true(is_valid_comment("1234567890a"))
  expect_false(is_valid_comment("short"))
  expect_false(is_valid_comment(""))
  expect_false(is_valid_comment("this comment is way too long for the field"))
})

# Order date validation
test_that("is_valid_order_date works", {
  expect_true(is_valid_order_date(as.Date("2023-01-01")))
  expect_true(is_valid_order_date(as.Date("2024-12-31")))
  expect_true(is_valid_order_date(as.Date("2026-02-24"))) # Current year
  expect_false(is_valid_order_date(as.Date("2022-12-31")))
  expect_false(is_valid_order_date(as.Date("2027-01-01")))
  expect_false(is_valid_order_date(NA))
})

# All fields valid
test_that("all_fields_valid works", {
  fake_input <- list(
    category = "Electronics",
    subcategory = "Phones",
    product = "iPhone",
    quantity = 2,
    comment = "Valid comment",
    orderDate = as.Date("2023-06-01")
  )
  expect_true(all_fields_valid(fake_input))
  fake_input$quantity <- 0
  expect_false(all_fields_valid(fake_input))
})
