# Load required packages
library(tibble)

# Create sample data
create_sample_data <- function() {
  tibble(
    Category = rep(c("Electronics", "Clothing", "Food"), each = 5),
    Subcategory = c(
      "Phones", "Computers", "Computers", "TVs", "Cameras", # Electronics
      "Shirts", "Shirts", "Pants", "Pants", "Accessories", # Clothing
      "Fruits", "Fruits", "Vegetables", "Dairy", "Snacks" # Food
    ),
    Product = c(
      "iPhone", "Laptop", "Desktop", "Smart TV", "DSLR Camera",
      "T-Shirt", "Button-up", "Jeans", "Khakis", "Watch",
      "Apple", "Orange", "Carrot", "Milk", "Chips"
    )
  )
}

# Load sample data
sample_data <- create_sample_data()
