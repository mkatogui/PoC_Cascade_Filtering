# Configure application options
options(
  repos = c(CRAN = "https://cloud.r-project.org"),
  warn = 1,                 # Print warnings but don't stop execution
  poc.log_level = "info"    # Standard production log level (debug, info, warn, error)
)

# Load required packages with error handling
required_packages <- c("shiny", "shinyFeedback", "shinyjs", "tibble", "dplyr", "magrittr")

# Try to load each package, with error handling
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message("Installing package: ", pkg)
    install.packages(pkg)
  }
  library(pkg, character.only = TRUE)
}

# Source modules and data
source("R/logger.R")      # Source logger first
source("R/validation.R")  # Source validation functions
source("R/filter_module_ui.R")
source("R/filter_module_server.R")
source("R/data.R")
source("R/ui.R")
source("R/server.R")

# Run the application
shinyApp(ui = app_ui(), server = app_server)
