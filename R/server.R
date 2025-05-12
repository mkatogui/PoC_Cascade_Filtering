# Define server logic
app_server <- function(input, output, session) {
    # Store selected values
  selected <- reactiveValues(
    category = NULL,
    subcategory = NULL,
    product = NULL,
    quantity = NULL,
    comment = NULL,
    orderDate = NULL
  )

  # Use a module-scoped reactiveVal to store filterValues
  filterValues <- reactiveVal()

  # Show modal when button is clicked
  observeEvent(input$showModal, {
    showModal(modalDialog(
      title = "Filter Options",
      
      # Insert the filter module UI
      filterModuleUI("filterMod"),
      
      # Modal buttons
      footer = tagList(
        actionButton("reset", "Reset", class = "btn-secondary"),
        shinyjs::hidden(actionButton("apply", "Apply Filter", class = "btn-primary")),
        modalButton("Cancel")
      ),
      # Changed from 'm' to 'l' for a larger modal
      size = "l",
      easyClose = TRUE
    ))
    # Initialize the filter module only once per modal open
    filterValues(filterModuleServer("filterMod", sample_data))
  })
  
  # Reset all selections in modal
  observeEvent(input$reset, {
    fv <- filterValues()
    if (!is.null(fv)) fv()$reset()
  })
  
  # Toggle Apply button visibility based on validation
  observe({
    fv <- filterValues()
    if (!is.null(fv)) {
      values <- fv()
      if (isTRUE(values$valid)) {
        shinyjs::show("apply")
      } else {
        shinyjs::hide("apply")
      }
    }
  })
  
  # Apply filters and close modal
  observeEvent(input$apply, {
    fv <- filterValues()
    if (!is.null(fv)) {
      values <- fv()
      if (isTRUE(values$valid)) {
        selected$category <- values$category
        selected$subcategory <- values$subcategory
        selected$product <- values$product
        selected$quantity <- values$quantity
        selected$comment <- values$comment
        selected$orderDate <- values$orderDate
        
        # Close the modal
        removeModal()
      } else {
        # Show notification if there are validation errors
        showNotification("Please fill in all required fields correctly before applying.", type = "error")
      }
    }
  })
  
  # Display the selection based on applied values
  output$selection <- renderPrint({
    # Collect all selections
    selections <- list(
      Category = if(!is.null(selected$category) && selected$category != "") 
                    selected$category else "None",
      Subcategory = if(!is.null(selected$subcategory) && selected$subcategory != "") 
                       selected$subcategory else "None",
      Product = if(!is.null(selected$product) && selected$product != "") 
                  selected$product else "None",
      Quantity = if(!is.null(selected$quantity)) selected$quantity else "None",
      Comment = if(!is.null(selected$comment) && selected$comment != "") 
                 selected$comment else "None",
      "Order Date" = if(!is.null(selected$orderDate)) 
                      format(selected$orderDate, "%Y-%m-%d") else "None"
    )
    
    # Print each selection
    for(name in names(selections)) {
      cat(name, ": ", selections[[name]], "\n", sep = "")
    }
      # Show validation status if any selections have been made
    if(!is.null(selected$quantity) || 
       (!is.null(selected$comment) && selected$comment != "") || 
       !is.null(selected$orderDate)) {
      
      cat("\n--- Validation Status ---\n")
      
      # Validate quantity
      if(!is.null(selected$quantity)) {
        qty_valid <- selected$quantity > 0
        cat("Quantity: ", ifelse(qty_valid, "✓ Valid", "✗ Invalid"), "\n")
      }
      
      # Validate comment
      if(!is.null(selected$comment)) {
        comment_length <- nchar(selected$comment)
        comment_empty <- comment_length == 0
        comment_valid <- if(comment_empty) TRUE else (comment_length >= 10 && comment_length <= 20)
        cat("Comment: ", 
            ifelse(comment_empty, "Not provided", 
                   ifelse(comment_valid, "✓ Valid", "✗ Invalid")), 
            "\n")
      }
      
      # Validate date
      if(!is.null(selected$orderDate)) {
        date_valid <- !is.na(selected$orderDate) && 
                     selected$orderDate >= as.Date("2023-01-01") && 
                     selected$orderDate <= as.Date("2024-12-31")
        cat("Date: ", ifelse(date_valid, "✓ Valid", "✗ Invalid"), "\n")
      }
    }
  })
}
