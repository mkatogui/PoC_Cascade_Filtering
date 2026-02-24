# Application Initialization
# Sources all components in designated order

# 1. Configuration & Constants
source("R/config.R")
source("R/constants.R")

# 2. Package Loading (explicit calls so renv can detect dependencies)
library(shiny)
library(shinyFeedback)
library(shinyjs)
library(tibble)
library(dplyr)
library(magrittr)
library(jsonlite)
library(digest)

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
