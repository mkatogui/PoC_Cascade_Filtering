# Production Dockerfile for PoC Cascade Filtering App
# Based on Rocker project (standard for R Docker images)
FROM rocker/r-ver:4.5.2

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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
RUN mkdir /app
WORKDIR /app

# Copy renv files
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R

# Restore dependencies to System Library for global visibility in CI
# Using Noble (Ubuntu 24.04) binary repository for speed
RUN R -e "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/noble/latest')); install.packages('renv'); renv::restore(library = '/usr/local/lib/R/site-library', confirm = FALSE)"

# Copy the rest of the app
COPY . .

# Expose the Shiny port
EXPOSE 3838

# Run the app
CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]
