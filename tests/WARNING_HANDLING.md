# Handling Warnings in Production R Environments

This document explains the modern approach used in this project to handle warnings and ensure clean, actionable logs in CI/CD environments.

## Background

R environments, especially during package loading and complex computations (like CSS/Sass compilation), can generate numerous warnings. In a production pipeline, these warnings can clutter logs and obscure real errors.

## Solution Architecture

### 1. Global Suppression Layer (.Rprofile)

The project uses a specialized `.Rprofile` that is automatically loaded in both development and CI/CD:

- **Warn Level**: Set to `options(warn = 1)` to print warnings immediately without stopping the build.
- **Unicode Control**: Emojis and Unicode icons are disabled via `options(cli.unicode = FALSE)` to ensure logs are compatible with all terminal formats.
- **Namespace Silencing**: Common Shiny and Tidyverse loading messages are suppressed using `suppressPackageWarnings()`.

### 2. Containerized Reliability

By using a Docker-based pipeline with a pre-synced `renv.lock`, we eliminate most environment-related warnings:

- **Pinned Versions**: Every package version is locked, preventing warnings from "bleeding edge" updates.
- **Binary Stability**: Forcing the use of the Posit binary mirror for Ubuntu Noble ensures that we aren't compiling from source, which is where most C++ compiler warnings originate.

### 3. CI/CD Environment Control

In the GitHub Actions workflow, we enforce a plain-text standard by setting:

```yaml
env:
  R_CLI_UNICODE: "false"
  CLI_UNICODE: "false"
  LANG: "C"
```

This ensures that even internal R packages like `rsconnect` or `cli` use standard text (e.g., [PASS]) instead of Unicode symbols.

## Best Practices for Tests

When writing new tests in `tests/testthat/`:

1.  **Avoid Emojis**: Do not use non-ASCII characters in `expect_match` or print statements.
2.  **Graceful Degrades**: Use `skip_if_not_installed()` for heavy dependencies like `shinytest2` to ensure the test suite runs even in partial environments.
3.  **Headless Configuration**: Always use headless browser modes for UI tests to avoid X11/server-side display warnings.

## Troubleshooting Failures

If a pipeline fails due to a warning-turned-error:

- Check the **Job Summary** table for the specific test file that failed.
- Look for the `Execution halted` message in the logs; the standard text indicator (e.g., FAILED) will point to the exact issue.
- Verify that your local `renv` is synced with `renv.lock` via `renv::status()`.
