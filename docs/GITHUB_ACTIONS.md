# GitHub Actions Workflow Documentation

This document explains the high-performance CI/CD workflow configuration in `.github/workflows/r-ci-cd.yml`.

## Overview

The CI/CD pipeline is designed for speed, reproducibility, and high visibility. It uses a container-based strategy with Docker and GitHub Container Registry (GHCR) to ensure the exact same R environment is used for testing and deployment.

## Architecture

The workflow consists of three main stages:

### 1. Build Image (Environment Recycling)

Instead of installing R packages from scratch on every run, we use a "Build-on-Change" strategy:

- **Hashing**: A unique SHA-256 hash is generated from `renv.lock` and `Dockerfile`.
- **Registry Check**: The workflow checks if a Docker image with this hash already exists in GHCR.
- **Recycling**: If the image exists, the build is skipped, saving ~5-10 minutes.
- **Binary Mirror**: We use the Posit Package Manager binary mirror for Ubuntu Noble to ensure package installations are nearly instantaneous.

### 2. Testing (Multi-Tier)

All tests are executed inside the Docker container to guarantee environment parity:

- **Unit Tests**: Verifies core validation logic in `R/validation.R`.
- **Integration Tests**: Uses `shinytest2` to simulate a browser session. It navigates the cascading dropdowns and verifies that the UI state correctly updates.
- **Headless Mode**: Integration tests run in a headless Chromium browser pre-installed in the Docker image.

### 3. Deployment

Automated deployment to shinyapps.io occurs only when all tests pass:

- **Consistency**: The deployment job runs in the same container as the tests.
- **Credentials**: Uses GitHub Repository Secrets (`SHINYAPPS_NAME`, `SHINYAPPS_TOKEN`, `SHINYAPPS_SECRET`).
- **Safety**: Includes a fallback mechanism to construct the app URL if the standard API return is missing it.

## Key Environment Variables

- `R_CLI_UNICODE`: Set to `false` to ensure logs are professional and emoji-free.
- `RENV_CONFIG_ACTIVATE`: Set to `FALSE` in CI to prevent `renv` from auto-loading, as the container already has the correct system library.
- `R_LIBS_SITE`: Pointed to `/usr/local/lib/R/site-library` for global visibility.

## Observability

The pipeline provides high-visibility feedback via **GitHub Job Summaries**:
- **Test Results**: A Markdown table showing passes/failures and details on any errors.
- **Deployment Status**: A summary including the live URL and recycling status.

## Troubleshooting

1. **Build Failure**: Check if a package has been removed from the CRAN archive; the Dockerfile is configured to prioritize the binary mirror to mitigate this.
2. **Integration Test Failure**: These tests can be sensitive to timeouts; the timeout is set to 20s to ensure stability.
3. **Missing Emojis**: This is intentional. The project enforces a strictly plain-text output for professional logs.
