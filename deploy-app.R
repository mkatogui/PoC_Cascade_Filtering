# App file optimized for deployment to shinyapps.io
# This file handles dependencies more explicitly

# Set CRAN mirror for package installations
if (length(getOption("repos")) <= 1) {
  options(repos = c(CRAN = "https://cloud.r-project.org"))
}

# Configure warning handling
options(warn = 1)  # Print warnings but don't stop execution

# Define required packages with minimal versions
required_packages <- c(
  "shiny", 
  "shinyFeedback", 
  "shinyjs", 
  "tibble"
)

# Error function for missing packages - but don't stop execution in deployment
check_packages <- function(pkgs) {
  tryCatch({
    missing <- setdiff(pkgs, rownames(installed.packages()))
    if (length(missing) > 0) {
      message("Missing required packages: ", paste(missing, collapse = ", "))
      # In deployment environments, we'll continue anyway
    }
  }, error = function(e) {
    message("Error checking packages: ", e$message)
  })
}

# Check packages
check_packages(required_packages)

# Load packages with error handling
for (pkg in required_packages) {
  tryCatch({
    library(pkg, character.only = TRUE)
  }, error = function(e) {
    message("Error loading package ", pkg, ": ", e$message)
  })
}

# Source modules and data
source("R/validation.R")  # Source validation functions first
source("R/filter_module_ui.R")
source("R/filter_module_server.R")
source("R/data.R")
source("R/ui.R")
source("R/server.R")

# Run the application
shinyApp(ui = app_ui(), server = app_server)
