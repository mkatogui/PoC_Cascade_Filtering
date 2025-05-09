# Validation functions for filter module

# Function to validate quantity - must be positive number
validate_quantity <- function(quantity) {
  if (is.null(quantity) || is.na(quantity) || quantity <= 0) {
    return(FALSE)
  }
  return(TRUE)
}

# Function to validate comment - must be between 10-20 characters
validate_comment <- function(comment) {
  if (is.null(comment)) {
    return(FALSE) # Comment is required
  }
  
  comment_length <- nchar(comment)
  if (comment_length < 10 || comment_length > 20) {
    return(FALSE)
  }
  
  return(TRUE)
}

# Function to validate date - must be between 2023-01-01 and 2024-12-31
validate_date <- function(date) {
  if (is.null(date) || is.na(date)) {
    return(FALSE)
  }
  
  min_date <- as.Date("2023-01-01")
  max_date <- as.Date("2024-12-31")
  
  if (date < min_date || date > max_date) {
    return(FALSE)
  }
  
  return(TRUE)
}

# Function to validate category/subcategory/product selections
validate_selections <- function(category, subcategory, product) {
  if (is.null(category) || category == "" || 
      is.null(subcategory) || subcategory == "" || 
      is.null(product) || product == "") {
    return(FALSE)
  }
  
  return(TRUE)
}

# Validate all fields
validate_all_fields <- function(category, subcategory, product, quantity, comment, date) {
  selections_valid <- validate_selections(category, subcategory, product)
  quantity_valid <- validate_quantity(quantity)
  comment_valid <- validate_comment(comment)
  date_valid <- validate_date(date)
  
  return(selections_valid && quantity_valid && comment_valid && date_valid)
}

# Additional validation functions
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
