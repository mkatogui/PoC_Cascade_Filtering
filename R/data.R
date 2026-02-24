# Sample data for PoC Cascade Filtering App
# Generated dynamically to demonstrate cascading relationships

sample_data <- tibble::tribble(
  ~Category,     ~Subcategory,    ~Product,
  "Electronics", "Phones",        "iPhone",
  "Electronics", "Phones",        "Samsung Galaxy",
  "Electronics", "Laptops",       "MacBook Pro",
  "Electronics", "Laptops",       "Dell XPS",
  "Clothing",    "Men's",         "T-Shirt",
  "Clothing",    "Men's",         "Jeans",
  "Clothing",    "Women's",       "Dress",
  "Clothing",    "Women's",       "Skirt",
  "Home",        "Living Room",   "Sofa",
  "Home",        "Living Room",   "Coffee Table",
  "Home",        "Kitchen",       "Toaster",
  "Home",        "Kitchen",       "Blender"
)

# Defensive logging check (Point 26)
if (exists("log_info")) {
  log_info("DATA_LOADED", "Sample data loaded successfully", rows = nrow(sample_data))
} else {
  message("DATA_LOADED: Sample data loaded successfully (logger not available yet)")
}
