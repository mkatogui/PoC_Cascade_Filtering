# Initialization script for PoC Cascade Filtering App
# Sources all components in correct order

# 1. Configuration & Constants
source("R/config.R")
source("R/constants.R")

# 2. Logging & Utilities
source("R/logger.R")
source("R/validation.R")

# 3. Data & Core Logic
source("R/data.R")
source("R/filter_module_ui.R")
source("R/filter_module_server.R")
source("R/ui.R")
source("R/server.R")

# 4. Global Env Check (Point 2)
check_dependencies <- function() {
  required <- c("shiny", "shinyjs", "shinyFeedback", "dplyr", "tibble", "jsonlite", "digest")
  missing <- required[!sapply(required, requireNamespace, quietly = TRUE)]

  if (length(missing) > 0) {
    stop(paste("Missing required packages:", paste(missing, collapse = ", ")))
  }
}

check_dependencies()
log_info("INIT_COMPLETE", "Application components sourced successfully")
