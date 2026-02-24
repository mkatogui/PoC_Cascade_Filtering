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
      numericInput(ns("quantity"), QUANTITY_LABEL, value = 1, min = 0, step = 1),
      textInput(ns("comment"), COMMENT_LABEL, value = "", placeholder = "Required"),
      dateInput(ns("orderDate"), "Order Date *", value = DEFAULT_DATE, min = MIN_ORDER_DATE, max = MAX_ORDER_DATE)
    ),
    # Real-time filter display
    div(
      h5("Current Selection:"),
      verbatimTextOutput(ns("modalSelection"))
    )
  )
}
