# Filter Module UI function
filterModuleUI <- function(id) {
  ns <- NS(id)
  tagList(
    useShinyFeedback(),
    
    # Add some custom CSS for better styling
    tags$style(HTML("
      .filter-section {
        margin-bottom: 20px;
        padding: 15px;
        border-radius: 5px;
        background-color: #f9f9f9;
      }
      .filter-title {
        margin-top: 0;
        margin-bottom: 15px;
        color: #2c3e50;
        border-bottom: 1px solid #ddd;
        padding-bottom: 5px;
      }
      .feedback-section {
        margin-top: 15px;
        padding: 10px;
        background-color: #f8f9fa;
        border-radius: 4px;
      }
      .required-label:after {
        content: ' *';
        color: red;
      }
    ")),
    
    # Product Filter Section
    div(class = "filter-section",
      h4(class = "filter-title", "Product Filters"),
      selectInput(ns("category"), "Category *:", choices = c("Select..." = "")),
      selectInput(ns("subcategory"), "Subcategory *:", choices = c("Select..." = "")),
      selectInput(ns("product"), "Product *:", choices = c("Select..." = ""))
    ),
    
    # Additional Information Section
    div(class = "filter-section",
      h4(class = "filter-title", "Additional Information"),
      numericInput(ns("quantity"), "Quantity *:", value = 1, min = 0, step = 1),
      helpText("Enter a positive number (required)"),
      textInput(ns("comment"), "Comment *:", value = "", placeholder = "10-20 characters"),
      helpText("Comment must be between 10-20 characters (required)"),
      dateInput(ns("orderDate"), "Order Date *:", value = Sys.Date(), min = "2023-01-01", max = "2024-12-31"),
      helpText("Select a date between Jan 1, 2023 and Dec 31, 2024 (required)")
    ),
    
    # Real-time filter display
    div(class = "feedback-section",
      h5("Current Selection:"),
      verbatimTextOutput(ns("modalSelection"))
    )
  )
}

# Filter Module Server function
filterModuleServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    # Initialize the category dropdown
    observe({
      updateSelectInput(session, "category", 
                       choices = c("Select..." = "", unique(data$Category)))
    })
    
    # Update subcategory based on selected category
    observeEvent(input$category, {
      if(input$category != "") {
        # Filter subcategories using dplyr
        subcats <- data %>%
          filter(Category == input$category) %>%
          pull(Subcategory) %>%
          unique()
        
        updateSelectInput(session, "subcategory", 
                         choices = c("Select..." = "", subcats))
        # Reset product dropdown
        updateSelectInput(session, "product", choices = c("Select..." = ""))
      } else {
        # Reset both dropdowns if category is cleared
        updateSelectInput(session, "subcategory", choices = c("Select..." = ""))
        updateSelectInput(session, "product", choices = c("Select..." = ""))
      }
    })
    
    # Update product based on selected subcategory
    observeEvent(input$subcategory, {
      if(input$subcategory != "") {
        # Filter products using dplyr
        prods <- data %>%
          filter(Category == input$category, 
                 Subcategory == input$subcategory) %>%
          pull(Product) %>%
          unique()
        
        updateSelectInput(session, "product", 
                         choices = c("Select..." = "", prods))
      } else {
        # Reset product dropdown if subcategory is cleared
        updateSelectInput(session, "product", choices = c("Select..." = ""))
      }
    })
    
    # Reset all selections
    resetSelections <- function() {
      updateSelectInput(session, "category", selected = "")
      updateSelectInput(session, "subcategory", choices = c("Select..." = ""))
      updateSelectInput(session, "product", choices = c("Select..." = ""))
      updateNumericInput(session, "quantity", value = 1)
      updateTextInput(session, "comment", value = "")
      updateDateInput(session, "orderDate", value = Sys.Date())
    }
    
    # Validation feedback
    observe({
      shinyFeedback::feedbackDanger("category", !is_valid_category(input$category), "Required")
      shinyFeedback::feedbackDanger("subcategory", !is_valid_subcategory(input$subcategory), "Required")
      shinyFeedback::feedbackDanger("product", !is_valid_product(input$product), "Required")
      shinyFeedback::feedbackDanger("quantity", !is_valid_quantity(input$quantity), "Must be > 0")
      shinyFeedback::feedbackDanger("comment", !is_valid_comment(input$comment), "10-20 characters required")
      shinyFeedback::feedbackDanger("orderDate", !is_valid_order_date(input$orderDate), "Date out of range")
    })
    
    # Display real-time selections
    output$modalSelection <- renderPrint({
      # Get current selections from the modal inputs
      current_selections <- list(
        Category = if(is_valid_category(input$category)) input$category else "None",
        Subcategory = if(is_valid_subcategory(input$subcategory)) input$subcategory else "None",
        Product = if(is_valid_product(input$product)) input$product else "None",
        Quantity = input$quantity,
        Comment = if(nchar(input$comment) > 0) input$comment else "None",
        "Order Date" = format(input$orderDate, "%Y-%m-%d")
      )
      
      # Print each selection
      for(name in names(current_selections)) {
        cat(name, ": ", current_selections[[name]], "\n", sep = "")
      }
      
      # Show validation status
      cat("\n--- Validation Status ---\n")
      cat("Category: ", ifelse(is_valid_category(input$category), "✓ Valid", "✗ Invalid"), "\n")
      cat("Subcategory: ", ifelse(is_valid_subcategory(input$subcategory), "✓ Valid", "✗ Invalid"), "\n")
      cat("Product: ", ifelse(is_valid_product(input$product), "✓ Valid", "✗ Invalid"), "\n")
      cat("Quantity: ", ifelse(is_valid_quantity(input$quantity), "✓ Valid", "✗ Invalid"), "\n")
      cat("Comment: ", ifelse(is_valid_comment(input$comment), "✓ Valid", "✗ Invalid"), "\n")
      cat("Date: ", ifelse(is_valid_order_date(input$orderDate), "✓ Valid", "✗ Invalid"), "\n")
      
      # If filters are applied, show a preview of how many items will be filtered
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
    
    # Return reactive expression with current values
    return(reactive({
      # Validate inputs before returning
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
