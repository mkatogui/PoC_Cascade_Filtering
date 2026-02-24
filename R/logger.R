# Lightweight logging layer for production Shiny
# Logs to stderr for capture by container runtimes and shinyapps.io

log_event <- function(level, event, message, ...) {
  # Log level definitions
  levels <- c(debug = 1, info = 2, warn = 3, error = 4)
  
  # Normalize severity and handle unknown levels gracefully
  level_name <- tolower(level)
  if (!(level_name %in% names(levels))) {
    level_name <- "info" # Safe default for unknown levels
  }
  
  current_level <- getOption("poc.log_level", "info")
  current_level_name <- tolower(current_level)
  if (!(current_level_name %in% names(levels))) {
    current_level_name <- "info"
  }
  
  # Only log if the level is high enough
  if (levels[level_name] < levels[current_level_name]) {
    return(invisible(NULL))
  }
  
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  level_tag <- paste0("[", toupper(level), "]")
  
  # Construct log message
  metadata <- list(...)
  metadata_str <- ""
  if (length(metadata) > 0) {
    metadata_str <- paste0(" | ", paste(names(metadata), metadata, sep = "=", collapse = " "))
  }
  
  log_msg <- sprintf("%s %s %s: %s%s", timestamp, level_tag, event, message, metadata_str)
  
  # Write to stderr (safe for Shiny and Docker logs)
  cat(log_msg, "\n", file = stderr())
}

# Sugar functions for common levels
log_info <- function(event, message, ...) log_event("info", event, message, ...)
log_warn <- function(event, message, ...) log_event("warn", event, message, ...)
log_error <- function(event, message, ...) log_event("error", event, message, ...)
