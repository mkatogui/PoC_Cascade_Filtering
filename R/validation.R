# Validation logic for filter module

# --- Low-level Validators ---

is_valid_category <- function(category) {
  # Guard against vectors/non-character
  if (length(category) != 1 || !is.character(category)) return(FALSE)
  if (is.na(category)) return(FALSE)
  nzchar(category)
}

is_valid_subcategory <- function(subcategory, category) {
  if (length(subcategory) != 1 || !is.character(subcategory)) return(FALSE)
  if (is.na(subcategory)) return(FALSE)
  nzchar(subcategory) && is_valid_category(category)
}

is_valid_product <- function(product, subcategory, category) {
  if (length(product) != 1 || !is.character(product)) return(FALSE)
  if (is.na(product)) return(FALSE)
  nzchar(product) && is_valid_subcategory(subcategory, category)
}

is_valid_quantity <- function(quantity) {
  # Harden checks: must be scalar, numeric, finite, positive, and integer
  if (length(quantity) != 1 || !is.numeric(quantity)) return(FALSE)
  if (!is.finite(quantity)) return(FALSE)

  quantity > 0 && floor(quantity) == quantity
}

is_valid_comment <- function(comment) {
  # Decide: Required Len 10-20
  if (length(comment) != 1 || !is.character(comment)) return(FALSE)
  if (is.na(comment)) return(FALSE)

  len <- nchar(comment)
  len >= COMMENT_MIN_LENGTH && len <= COMMENT_MAX_LENGTH
}

is_valid_order_date <- function(orderDate) {
  # Guard against non-Date or vectors
  if (length(orderDate) != 1 || !inherits(orderDate, "Date")) return(FALSE)
  if (is.na(orderDate)) return(FALSE)

  orderDate >= MIN_ORDER_DATE && orderDate <= MAX_ORDER_DATE
}

# --- Aggregators ---

all_fields_valid <- function(input) {
  # Defensive reading from input
  cat <- tryCatch(input$category, error = function(e) NULL)
  subcat <- tryCatch(input$subcategory, error = function(e) NULL)
  prod <- tryCatch(input$product, error = function(e) NULL)
  qty <- tryCatch(input$quantity, error = function(e) NULL)
  cmt <- tryCatch(input$comment, error = function(e) NULL)
  dt <- tryCatch(input$orderDate, error = function(e) NULL)

  # Ensure scalar TRUE/FALSE
  valid <- is_valid_category(cat) &&
    is_valid_subcategory(subcat, cat) &&
    is_valid_product(prod, subcat, cat) &&
    is_valid_quantity(qty) &&
    is_valid_comment(cmt) &&
    is_valid_order_date(dt)

  isTRUE(valid)
}
