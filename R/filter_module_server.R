# Filter Module Server function
filterModuleServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    observe({
      updateSelectInput(session, "category", 
                       choices = c("Select..." = "", unique(data$Category)))
    })
    observeEvent(input$category, {
      if(input$category != "") {
        subcats <- data %>%
          filter(Category == input$category) %>%
          pull(Subcategory) %>%
          unique()
        updateSelectInput(session, "subcategory", 
                         choices = c("Select..." = "", subcats))
        updateSelectInput(session, "product", choices = c("Select..." = ""))
      } else {
        updateSelectInput(session, "subcategory", choices = c("Select..." = ""))
        updateSelectInput(session, "product", choices = c("Select..." = ""))
      }
    })
    observeEvent(input$subcategory, {
      if(input$subcategory != "") {
        prods <- data %>%
          filter(Category == input$category, 
                 Subcategory == input$subcategory) %>%
          pull(Product) %>%
          unique()
        updateSelectInput(session, "product", 
                         choices = c("Select..." = "", prods))
      } else {
        updateSelectInput(session, "product", choices = c("Select..." = ""))
      }
    })
    resetSelections <- function() {
      updateSelectInput(session, "category", selected = "")
      updateSelectInput(session, "subcategory", choices = c("Select..." = ""))
      updateSelectInput(session, "product", choices = c("Select..." = ""))
      updateNumericInput(session, "quantity", value = 1)
      updateTextInput(session, "comment", value = "")
      updateDateInput(session, "orderDate", value = Sys.Date())
    }
    observe({
      shinyFeedback::feedbackDanger("category", !is_valid_category(input$category), "Required")
      shinyFeedback::feedbackDanger("subcategory", !is_valid_subcategory(input$subcategory), "Required")
      shinyFeedback::feedbackDanger("product", !is_valid_product(input$product), "Required")
      shinyFeedback::feedbackDanger("quantity", !is_valid_quantity(input$quantity), "Must be > 0")
      shinyFeedback::feedbackDanger("comment", !is_valid_comment(input$comment), "10-20 characters required")
      shinyFeedback::feedbackDanger("orderDate", !is_valid_order_date(input$orderDate), "Date out of range")
    })
    output$modalSelection <- renderPrint({
      current_selections <- list(
        Category = if(is_valid_category(input$category)) input$category else "None",
        Subcategory = if(is_valid_subcategory(input$subcategory)) input$subcategory else "None",
        Product = if(is_valid_product(input$product)) input$product else "None",
        Quantity = input$quantity,
        Comment = if(nchar(input$comment) > 0) input$comment else "None",
        "Order Date" = format(input$orderDate, "%Y-%m-%d")
      )
      for(name in names(current_selections)) {
        cat(name, ": ", current_selections[[name]], "\n", sep = "")
      }
      cat("\n--- Validation Status ---\n")
      cat("Category: ", ifelse(is_valid_category(input$category), "Valid", "Invalid"), "\n")
      cat("Subcategory: ", ifelse(is_valid_subcategory(input$subcategory), "Valid", "Invalid"), "\n")
      cat("Product: ", ifelse(is_valid_product(input$product), "Valid", "Invalid"), "\n")
      cat("Quantity: ", ifelse(is_valid_quantity(input$quantity), "Valid", "Invalid"), "\n")
      cat("Comment: ", ifelse(is_valid_comment(input$comment), "Valid", "Invalid"), "\n")
      cat("Date: ", ifelse(is_valid_order_date(input$orderDate), "Valid", "Invalid"), "\n")
      if(is_valid_category(input$category)) {
        cat("\n--- Filter Results ---\n")
        filtered_data <- data
        if(is_valid_category(input$category)) {
          filtered_data <- filtered_data %>% filter(Category == input$category)
        }
        if(is_valid_subcategory(input$subcategory)) {
          filtered_data <- filtered_data %>% filter(Subcategory == input$subcategory)
        }
        if(is_valid_product(input$product)) {
          filtered_data <- filtered_data %>% filter(Product == input$product)
        }
        cat("Items matching filters: ", nrow(filtered_data), " out of ", nrow(data), sep = "")
      }
    })
    return(reactive({
      valid <- all_fields_valid(input)
      list(
        category = input$category,
        subcategory = input$subcategory,
        product = input$product,
        quantity = input$quantity,
        comment = input$comment,
        orderDate = input$orderDate,
        valid = valid,
        reset = resetSelections
      )
    }))
  })
}
