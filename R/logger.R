# Lightweight JSON-line logging layer for production
# Logs to stderr for capture by container runtimes

log_event <- function(level, event, message, ...) {
  # Log level definitions
  levels <- c(debug = 1, info = 2, warn = 3, error = 4)

  # Normalize severity
  level_name <- tolower(level)
  if (!(level_name %in% names(levels))) {
    level_name <- "info"
  }

  current_level <- getOption("poc.log_level", "info")
  current_level_name <- tolower(current_level)
  if (!(current_level_name %in% names(levels))) {
    current_level_name <- "info"
  }

  # Severity filter
  if (levels[level_name] < levels[current_level_name]) {
    return(invisible(NULL))
  }

  log_obj <- list(
    timestamp = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z"),
    level = toupper(level_name),
    event = event,
    message = message,
    metadata = list(...)
  )

  # Write as single-line JSON to stderr
  cat(jsonlite::toJSON(log_obj, auto_unbox = TRUE), "\n", file = stderr())
}

# Logger Sugars
log_debug <- function(event, message, ...) {
  log_event("debug", event, message, ...)
}
log_info <- function(event, message, ...) {
  log_event("info", event, message, ...)
}
log_warn <- function(event, message, ...) {
  log_event("warn", event, message, ...)
}
log_error <- function(event, message, ...) {
  log_event("error", event, message, ...)
}
