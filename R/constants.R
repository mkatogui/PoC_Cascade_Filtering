# Application Constants
# Single source of truth for validation rules and UI text

# Date constraints
MIN_ORDER_DATE <- as.Date("2023-01-01")
MAX_ORDER_DATE <- as.Date("2026-12-31")
DEFAULT_DATE   <- as.Date("2024-01-01")

# Comment constraints
COMMENT_MIN_LENGTH <- 10
COMMENT_MAX_LENGTH <- 20
COMMENT_REQUIRED   <- TRUE

# UI Display strings
ORDER_DATE_RULE_TEXT <- sprintf(
  "Must be between %s and %s", 
  format(MIN_ORDER_DATE, "%Y-%m-%d"), 
  format(MAX_ORDER_DATE, "%Y-%m-%d")
)

QUANTITY_LABEL <- "Quantity (positive integer)"
COMMENT_LABEL  <- sprintf("Comment (%d-%d characters)", COMMENT_MIN_LENGTH, COMMENT_MAX_LENGTH)
