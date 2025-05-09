# Define UI - Changed to use a button that opens a modal
app_ui <- function() {
  fluidPage(
    # Use custom CSS
    tags$head(
      tags$style(HTML("
        .app-header {
          background-color: #f5f5f5;
          padding: 20px;
          border-radius: 5px;
          margin-bottom: 20px;
        }
        .info-box {
          background-color: #e8f4f8;
          padding: 15px;
          border-left: 4px solid #5bc0de;
          margin-top: 20px;
          border-radius: 4px;
        }
        .selection-display {
          background-color: #f9f9f9;
          padding: 15px;
          border-radius: 5px;
          margin-top: 20px;
          border: 1px solid #ddd;
        }
      "))
    ),
    
    titlePanel("Cascade Filter with Validation"),
    
    # Main content
    fluidRow(
      column(
        width = 10,
        offset = 1,
        
        # Header section
        div(class = "app-header",
          h3("Interactive Filter Demo with Input Validation"),
          p("This app demonstrates a modular cascading filter system with input validation."),
          actionButton("showModal", "Open Filter", class = "btn-primary btn-lg"),
          hr()
        ),
        
        # Info box with validation rules
        div(class = "info-box",
          h4("Input Validation Rules:"),
          tags$ul(
            tags$li(strong("Quantity:"), "Must be a positive number"),
            tags$li(strong("Comment:"), "Must be between 10-20 characters"),
            tags$li(strong("Order Date:"), "Must be between January 1, 2023 and December 31, 2024")
          )
        ),
        
        # Selection display
        div(class = "selection-display",
          h4("Current Selection:"),
          verbatimTextOutput("selection")
        )
      )
    )
  )
}
