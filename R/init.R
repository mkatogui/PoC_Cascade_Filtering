# Initialization script for PoC Cascade Filtering App
# Sources all components in correct order

# 1. Logging FIRST (Point 6, 16)
# Explicitly source into GlobalEnv to ensure visibility on shinyapps.io
source("R/logger.R", local = .GlobalEnv)

# Verify logger is available (Defensive)
if (!exists("log_info", envir = .GlobalEnv)) {
  log_info <- function(...) {
    message("Fallback log_info: ", paste(...))
  }
}

# 2. Configuration & Constants
source("R/config.R", local = .GlobalEnv)
source("R/constants.R", local = .GlobalEnv)

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
source("R/validation.R", local = .GlobalEnv)
source("R/data.R", local = .GlobalEnv)

# 5. UI & Server
source("R/filter_module_ui.R", local = .GlobalEnv)
source("R/filter_module_server.R", local = .GlobalEnv)
source("R/ui.R", local = .GlobalEnv)
source("R/server.R", local = .GlobalEnv)

log_info("INIT_COMPLETE", "Application components sourced successfully")
