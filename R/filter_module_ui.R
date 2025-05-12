# Filter Module UI function
filterModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    useShinyFeedback(),
    # Product Filter Section
    div(
      h4("Product Filters"),
      selectInput(ns("category"), "Category *", choices = c("Select..." = "")),
      selectInput(ns("subcategory"), "Subcategory *", choices = c("Select..." = "")),
      selectInput(ns("product"), "Product *", choices = c("Select..." = ""))
    ),
    # Additional Information Section
    div(
      h4("Additional Information"),
      numericInput(ns("quantity"), "Quantity *", value = 1, min = 0, step = 1),
      textInput(ns("comment"), "Comment *", value = "", placeholder = "10-20 characters"),
      dateInput(ns("orderDate"), "Order Date *", value = Sys.Date(), min = "2023-01-01", max = "2024-12-31")
    ),
    # Real-time filter display
    div(
      h5("Current Selection:"),
      verbatimTextOutput(ns("modalSelection"))
    )
  )
}
