# Enhanced application launcher for shinyapps.io deployment
# This file is designed to be more robust in handling dependency issues

# Set CRAN mirror for package installations (with fallback)
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Configure warning handling
options(warn = 1)  # Print warnings but don't stop execution

# Define required packages
required_packages <- c(
  "shiny", 
  "shinyFeedback", 
  "shinyjs", 
  "tibble",
  "dplyr",
  "magrittr",
  "tidyr",
  "readr"
)

# Function to check and install packages
ensure_packages <- function(pkgs) {
  missing_pkgs <- c()
  
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("Package not installed: ", pkg, ". Attempting to install...")
      tryCatch({
        install.packages(pkg)
        if (!requireNamespace(pkg, quietly = TRUE)) {
          missing_pkgs <- c(missing_pkgs, pkg)
        }
      }, error = function(e) {
        message("Failed to install package ", pkg, ": ", e$message)
        missing_pkgs <- c(missing_pkgs, pkg)
      })
    }
  }
  
  if (length(missing_pkgs) > 0) {
    warning("Could not install the following packages: ", 
           paste(missing_pkgs, collapse = ", "), 
           ". The application may not function correctly.")
  }
  
  return(missing_pkgs)
}

# Check and install packages
missing <- ensure_packages(required_packages)

# Load packages with error handling
for (pkg in required_packages) {
  tryCatch({
    if (!is.element(pkg, missing)) {
      library(pkg, character.only = TRUE)
    }
  }, error = function(e) {
    warning("Error loading package ", pkg, ": ", e$message)
  })
}

# Print session info for debugging
message("Session Info:")
print(sessionInfo())

# Ensure we have the basic requirements to run
if (!requireNamespace("shiny", quietly = TRUE)) {
  stop("The 'shiny' package is required but could not be loaded.")
}

# Source modules and data with better error handling
source_with_check <- function(file_path) {
  if (!file.exists(file_path)) {
    warning("File does not exist: ", file_path)
    return(FALSE)
  }
  
  tryCatch({
    source(file_path)
    return(TRUE)
  }, error = function(e) {
    warning("Error sourcing file ", file_path, ": ", e$message)
    return(FALSE)
  })
}

# Source in order with validation
source_with_check("R/validation.R")  # Source validation functions first
source_with_check("R/filter_module_ui.R")
source_with_check("R/filter_module_server.R")
source_with_check("R/data.R")
source_with_check("R/ui.R")
source_with_check("R/server.R")

# Run the application
shinyApp(ui = app_ui(), server = app_server)
