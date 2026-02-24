# Define server logic
app_server <- function(input, output, session) {
  # Session-level correlation ID
  session_id <- paste0("sess_", substr(digest::digest(Sys.time()), 1, 8))
  log_info("APP_START", "Main app server logic started", session_id = session_id)

  # --- State Management ---

  # Store selected values
  selected <- reactiveValues(
    category = NULL,
    subcategory = NULL,
    product = NULL,
    quantity = NULL,
    comment = NULL,
    orderDate = NULL
  )

  # Instantiate the filter module ONCE at app start (Point 6)
  # This prevents observer accumulation over multiple modal cycles.
  module_out <- filterModuleServer("filterMod", sample_data)

  # --- Event Handlers ---

  # Show modal when button is clicked
  observeEvent(input$showModal, {
    log_info("MODAL_OPEN", "User clicked Open Filter button", session_id = session_id)

    showModal(modalDialog(
      title = "Filter Options",

      # Insert the filter module UI
      filterModuleUI("filterMod"),

      # Modal buttons
      footer = tagList(
        actionButton("reset", "Reset", class = "btn-secondary"),
        # Start as disabled instead of hidden (Point 14)
        shinyjs::disabled(actionButton("apply", "Apply Filter", class = "btn-primary")),
        modalButton("Cancel")
      ),
      size = "l",
      easyClose = TRUE
    ))
  })

  # Reset module inputs
  observeEvent(input$reset, {
    module_out()$reset()
  })

  # Toggle Apply button state based on validation (Point 14)
  observe({
    res <- module_out()
    if (isTRUE(res$valid)) {
      shinyjs::enable("apply")
    } else {
      shinyjs::disable("apply")
    }
  })

  # Apply filters and close modal
  observeEvent(input$apply, {
    log_info("FILTER_APPLY_CLICK", "User clicked Apply Filter button", session_id = session_id)

    res <- module_out()
    if (isTRUE(res$valid)) {
      selected$category    <- res$category
      selected$subcategory <- res$subcategory
      selected$product     <- res$product
      selected$quantity    <- res$quantity
      selected$comment     <- res$comment
      selected$orderDate   <- res$orderDate

      log_info("FILTER_SUCCESS", "Filters applied successfully",
        session_id = session_id,
        category = res$category,
        subcategory = res$subcategory,
        product = res$product,
        quantity = res$quantity
      )

      removeModal()
    } else {
      showNotification("Please fill in all required fields correctly.", type = "error")
    }
  })

  # --- Outputs ---

  # Display selection on main page
  output$selection <- renderPrint({
    # Helper to clean display
    get_val <- function(x) {
      if (is.null(x) || (is.character(x) && !nzchar(x))) "None" else x
    }

    selections <- list(
      Category    = get_val(selected$category),
      Subcategory = get_val(selected$subcategory),
      Product     = get_val(selected$product),
      Quantity    = get_val(selected$quantity),
      Comment     = get_val(selected$comment),
      "Order Date" = if (!is.null(selected$orderDate)) format(selected$orderDate, "%Y-%m-%d") else "None"
    )

    for (name in names(selections)) {
      cat(name, ": ", selections[[name]], "\n", sep = "")
    }

    # Show validation status using shared validators (Point 15)
    has_selection <- !is.null(selected$category) || !is.null(selected$quantity)

    if (has_selection) {
      cat("\n--- Validation Status ---\n")
      cat("Category: ", ifelse(is_valid_category(selected$category), "Valid", "Invalid"), "\n")
      cat("Subcategory: ", ifelse(is_valid_subcategory(selected$subcategory, selected$category), "Valid", "Invalid"), "\n")
      cat("Product: ", ifelse(is_valid_product(selected$product, selected$subcategory, selected$category), "Valid", "Invalid"), "\n")
      cat("Quantity: ", ifelse(is_valid_quantity(selected$quantity), "Valid", "Invalid"), "\n")
      cat("Comment: ", ifelse(is_valid_comment(selected$comment), "Valid", "Invalid"), "\n")
      cat("Date: ", ifelse(is_valid_order_date(selected$orderDate), "Valid", "Invalid"), "\n")
    }
  })
}
