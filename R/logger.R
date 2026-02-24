# Lightweight logging layer for production Shiny
# Logs to stderr for capture by container runtimes and shinyapps.io

log_event <- function(level, event, message, ...) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  # Use standard text indicators instead of symbols
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
