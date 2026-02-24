# Initialization script for PoC Cascade Filtering App
# Sources all components in correct order

# 1. Configuration & Constants
source("R/config.R")
source("R/constants.R")

# 2. Load Core Dependencies (Point 6, 26)
# Explicit library() calls are required for renv to detect usage
library(shiny)
library(shinyjs)
library(shinyFeedback)
library(dplyr)
library(tibble)
library(jsonlite)
library(digest)

# 3. Logging & Utilities
source("R/logger.R")
source("R/validation.R")

# 4. Data & Core Logic
source("R/data.R")
source("R/filter_module_ui.R")
source("R/filter_module_server.R")
source("R/ui.R")
source("R/server.R")

log_info("INIT_COMPLETE", "Application components sourced successfully")
