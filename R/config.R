# Production Application Configuration
# These options are sourced once at startup

options(
  # Package management
  repos = c(CRAN = "https://cloud.r-project.org"),

  # Error/Warning handling
  warn = 1, # Print warnings but don't stop execution

  # Application-specific options
  poc.log_level = "info", # (debug, info, warn, error)

  # Shiny performance/behavior
  shiny.sanitize.errors = FALSE # Set to TRUE in strictly hardened prod
)
