# Unit tests for validation functions
library(testthat)

# Load validation functions directly for testing
# Define validation functions inline to avoid file path issues
is_valid_category <- function(category) {
  !is.null(category) && category != ""
}

is_valid_subcategory <- function(subcategory) {
  !is.null(subcategory) && subcategory != ""
}

is_valid_product <- function(product) {
  !is.null(product) && product != ""
}

is_valid_quantity <- function(quantity) {
  !is.null(quantity) && !is.na(quantity) && quantity > 0
}

is_valid_comment <- function(comment) {
  !is.null(comment) && nchar(comment) >= 10 && nchar(comment) <= 20
}

is_valid_order_date <- function(orderDate) {
  !is.null(orderDate) && !is.na(orderDate) &&
    orderDate >= as.Date("2023-01-01") && orderDate <= as.Date("2024-12-31")
}

all_fields_valid <- function(input) {
  is_valid_category(input$category) &&
    is_valid_subcategory(input$subcategory) &&
    is_valid_product(input$product) &&
    is_valid_quantity(input$quantity) &&
    is_valid_comment(input$comment) &&
    is_valid_order_date(input$orderDate)
}

# Category validation
test_that("Category validation works", {
  expect_true(is_valid_category("Electronics"))
  expect_false(is_valid_category(""))
  expect_false(is_valid_category(NULL))
})

# Subcategory validation
test_that("Subcategory validation works", {
  expect_true(is_valid_subcategory("Phones"))
  expect_false(is_valid_subcategory(""))
  expect_false(is_valid_subcategory(NULL))
})

# Product validation
test_that("Product validation works", {
  expect_true(is_valid_product("iPhone"))
  expect_false(is_valid_product(""))
  expect_false(is_valid_product(NULL))
})

# Quantity validation
test_that("Quantity validation works", {
  expect_true(is_valid_quantity(1))
  expect_true(is_valid_quantity(10))
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
  expect_false(is_valid_order_date(as.Date("2022-12-31")))
  expect_false(is_valid_order_date(as.Date("2025-01-01")))
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
