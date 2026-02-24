# Production Dockerfile for PoC Cascade Filtering App
# Using Rocker 4.4.2 (Ubuntu Noble) - Pinned by digest for 100% reproducibility
FROM rocker/r-ver:4.4.2@sha256:d15904de22aebca1183f3f22b72f10b7f6c3ef6fd7922d4f8268e37a281e4b33

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    zlib1g-dev \
    # Headless browser (Chromium) for integration tests
    chromium-browser \
    libnss3 \
    libatk1.0-0t64 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2t64 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
RUN mkdir /app
WORKDIR /app

# Copy renv files
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R

# Restore dependencies from renv.lock to System Library
# Using Noble (Ubuntu 24.04) binary repository for speed
ENV R_LIBS_SITE="/usr/local/lib/R/site-library"
ENV RENV_PATHS_LIBRARY="/usr/local/lib/R/site-library"
ENV RENV_CONFIG_REPOS_OVERRIDE="https://packagemanager.posit.co/cran/__linux__/noble/latest"

RUN Rscript -e "options(repos = c(CRAN = Sys.getenv('RENV_CONFIG_REPOS_OVERRIDE'))); \
    install.packages('renv'); \
    # Install critical tools FIRST from binaries to satisfy dependencies \
    tools <- c('shiny', 'shinyFeedback', 'shinyjs', 'testthat', 'rsconnect', 'PKI', 'shinytest2'); \
    install.packages(tools); \
    # Restore the environment, using clean = FALSE to keep our tools \
    renv::restore(confirm = FALSE, clean = FALSE); \
    # Final check \
    installed <- installed.packages()[,'Package']; \
    missing <- setdiff(tools, installed); \
    if (length(missing) > 0) { \
    message('FAILED: Missing packages: ', paste(missing, collapse = ', ')); \
    quit(status = 1); \
    } else { \
    message('SUCCESS: All critical packages verified.'); \
    }"

# Copy the rest of the app
COPY . .

# Expose the Shiny port
EXPOSE 3838

# Run the app
CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]
