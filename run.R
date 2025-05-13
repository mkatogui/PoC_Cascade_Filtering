# BasicCascadeApp Launcher Script
# This file provides a consistent way to run the app with proper settings

# Set CRAN mirror for package installations
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Configure warning handling
options(warn = 1)  # Print warnings but don't stop execution

# Ensure required packages are installed
required_packages <- c("shiny", "shinyFeedback", "shinyjs", "tibble")
missing_packages <- setdiff(required_packages, rownames(installed.packages()))

if (length(missing_packages) > 0) {
  cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
  install.packages(missing_packages)
}

# Load packages with warning suppression
suppressWarnings({
  for (pkg in required_packages) {
    library(pkg, character.only = TRUE)
  }
})

# Run the app
cat("Starting BasicCascadeApp...\n")
shiny::runApp(".", launch.browser = TRUE)
