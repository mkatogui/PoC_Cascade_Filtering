# Initialization script for PoC Cascade Filtering App
# Sources all components in correct order

# 1. Logging FIRST (Point 6, 16)
# Ensure logger is available before any other component sources
source("R/logger.R")

# 2. Configuration & Constants
source("R/config.R")
source("R/constants.R")

# 3. Load Core Dependencies
# Explicit library() calls are required for renv to detect usage
library(shiny)
library(shinyjs)
library(shinyFeedback)
library(dplyr)
library(tibble)
library(jsonlite)
library(digest)

# 4. Utilities & Logic
source("R/validation.R")
source("R/data.R")

# 5. UI & Server
source("R/filter_module_ui.R")
source("R/filter_module_server.R")
source("R/ui.R")
source("R/server.R")

log_info("INIT_COMPLETE", "Application components sourced successfully")
