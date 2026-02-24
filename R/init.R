# Application Initialization
# Sources all components in designated order

# 1. Configuration & Constants
source("R/config.R")
source("R/constants.R")

# 2. Package Loading with Fail-Fast Check
required_packages <- c(
  "shiny", "shinyFeedback", "shinyjs", "tibble", "dplyr", "magrittr", "jsonlite", "digest"
)

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Missing required packages: ", paste(missing_packages, collapse = ", "),
    "\nPlease restore the environment using renv::restore() or rebuild the Docker container."
  )
}

# Load packages into current session
invisible(lapply(required_packages, library, character.only = TRUE))

# 3. Core Infrastructure
source("R/logger.R")
source("R/validation.R")

# 4. Data Layer
source("R/data.R")

# 5. Modules
source("R/filter_module_ui.R")
source("R/filter_module_server.R")

# 6. Main UI & Server
source("R/ui.R")
source("R/server.R")
