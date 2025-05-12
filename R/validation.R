# Validation functions for filter module

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
