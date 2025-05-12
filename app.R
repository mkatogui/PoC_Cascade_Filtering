library(shiny)
library(tidyverse)
library(shinyFeedback)  # For input validation feedback
library(shinyjs)  # Adding shinyjs for more responsive UI interactions

# Source modules and data
source("R/validation.R")  # Source validation functions first
source("R/filter_module_ui.R")
source("R/filter_module_server.R")
source("R/data.R")
source("R/ui.R")
source("R/server.R")

# Run the application
shinyApp(ui = app_ui(), server = app_server)
