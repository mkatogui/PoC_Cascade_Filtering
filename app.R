# Source all application components
source("R/init.R")

# Run the application
shinyApp(ui = app_ui(), server = app_server)
