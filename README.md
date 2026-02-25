# BasicCascadeApp

A modular Shiny app demonstrating a cascading filter system with strong input validation and a modal interface. 
This project serves as a production-ready R CI/CD template.

---

## Features

- **Cascading Dropdowns**: Category -> Subcategory -> Product, with strict ordering invariants.
- **Business Invariants**: Centralized in [R/constants.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/constants.R) for zero drift between UI and logic.
- **Validation**: Real-time, hardened type-checked validation with field-level feedback via `shinyFeedback`.
- **Apply Button**: UX-friendly toggling (disabled when invalid) to maintain layout stability.
- **Observability**: Structured JSON-line logging with session correlation IDs for production audit ([R/logger.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/logger.R)).
- **Versioning**: Automated semantic versioning and GitHub releases integrated into CI/CD.
- **Environment**: Deterministic builds via `renv` + pinned mirrors; runtime is offline-capable once image is built.

---

## Meta

- **Live Application:** [Visit the App](https://mkatogui.shinyapps.io/basiccascadeapp/)
- **Topics:** `shiny`, `r`, `production-ready`, `ci-cd`, `docker`, `renv`, `validation`, `modular-design`
- **Case Study:** [Production-Grade Shiny Engineering](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/docs/PRODUCTION_CASE_STUDY.md)
- **Deep Dive (Engineering):** [Engineering Case Study](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/docs/ENGINEERING_CASE_STUDY.md)

---

## Project Structure

```
PoC_Cascade_Filtering/
├── app.R              # Main entry point
├── launch.R           # Enhanced app launcher for deployment
├── README.md
├── renv.lock          # Pin-point dependency manifest
├── Dockerfile         # Hardened R 4.5.2 environment
├── R/                 # Application components
│   ├── config.R       # Global options
│   ├── constants.R    # Business invariants (Dates, Labels)
│   ├── logger.R       # JSON logging layer
│   ├── init.R         # Safe environment initialization
│   ├── validation.R   # Core validation logic
│   ├── data.R         # Sample data definitions
│   ├── filter_module_ui.R
│   ├── filter_module_server.R
│   ├── ui.R
│   └── server.R
├── tests/             # Comprehensive test suite
│   └── testthat/
│       ├── test-validation.R    # Unit tests
│       └── test-integration.R   # Browser-based E2E tests
└── BasicCascadeApp.Rproj
```

---

## How to Run

1. **Initialize Environment**:
    This project uses `renv` for dependency management. To restore the exact production environment:

    ```r
    if (!requireNamespace("renv", quietly = TRUE)) install.packages("renv")
    renv::restore()
    ```

2. **Run the App**:

    Open `app.R` in RStudio or VS Code and click "Run App", or run in R console:

    ```r
    shiny::runApp()
    ```

---

## Usage

1. Click **Open Filter** to open the modal.
2. Select a Category, Subcategory, and Product.
3. Enter Quantity, Comment, and Order Date.
4. The **Apply Filter** button **enables** only when all fields are valid.
5. Click **Apply Filter** to save your selections, which are then displayed in the main UI.
6. Use **Reset** to clear all fields in the modal.

---

## Validation Rules (Constants-Driven)

Rules are defined in [R/constants.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/constants.R):
- **Quantity**: Positive integer (scalar).
- **Comment**: 10-20 characters (required).
- **Order Date**: Between `2023-01-01` and `2026-12-31`.

---

## Code Quality and Modularity

- **filter_module_server.R**: Contains the server logic for the filter modal, including cascading dropdowns, validation, and summary output.
- **filter_module_ui.R**: Contains the UI for the filter modal.
- **validation.R**: All validation logic is centralized here for maintainability.
- **data.R**: Defines the sample data used for filtering.
- **ui.R** and **server.R**: Main app UI and server logic, integrating the filter module.

---

## Testing

This project includes both unit tests and integration tests:

1. **Unit Tests**: Verifying validation logic in `R/validation.R` for core business rules (quantity, date ranges, comment length).
2. **Integration Tests**: Full end-to-end browser simulation using `shinytest2`. This validates the cascading dropdown logic ("Electronics" -> "Phones") and ensures that validation state transitions (like the Apply button disabling) work correctly across the entire session.

---

## Continuous Integration / Continuous Deployment

This project uses GitHub Actions for CI/CD to automatically:

1. **Test the app** whenever code is pushed or pull requests are made.
2. **Deploy to shinyapps.io** when changes are pushed to the main branch.

The CI/CD pipeline:
- **Intelligent Image Recycling**: Uses content-based hashing of `renv.lock` and `Dockerfile` to reuse existing images in GHCR.
- **Automated Verification**: Runs both unit and integration tests in a headless container environment with Google Chrome.
- **Production-Strict**: Builds only deploy if 100% of tests pass.
- **Reliable Mirroring**: Uses Posit Package Manager binary mirrors for stable lifecycle management.
- **Structured Logging**: Built-in observability layer ([R/logger.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/logger.R)) for production auditing.
- **Semantic Release**: Automatic versioned tagging on every successful merge to the main branch.

---

## License

MIT License

---

## Project Files

### Root Directory
- [.Rprofile](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/.Rprofile)
- [.gitattributes](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/.gitattributes)
- [.gitignore](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/.gitignore)
- [BasicCascadeApp.Rproj](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/BasicCascadeApp.Rproj)
- [Dockerfile](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/Dockerfile)
- [README.md](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/README.md)
- [app.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/app.R)
- [renv.lock](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/renv.lock)
- [shinyapps.yml](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/shinyapps.yml)

### Source Code (`R/`)
- [config.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/config.R)
- [constants.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/constants.R)
- [data.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/data.R)
- [filter_module_server.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/filter_module_server.R)
- [filter_module_ui.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/filter_module_ui.R)
- [init.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/init.R)
- [logger.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/logger.R)
- [server.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/server.R)
- [ui.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/ui.R)
- [validation.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/R/validation.R)

### Documentation (`docs/`)
- [ENGINEERING_CASE_STUDY.md](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/docs/ENGINEERING_CASE_STUDY.md)
- [GITHUB_ACTIONS.md](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/docs/GITHUB_ACTIONS.md)
- [PRODUCTION_CASE_STUDY.md](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/docs/PRODUCTION_CASE_STUDY.md)

### Tests (`tests/`)
- [testthat.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/tests/testthat.R)
- [WARNING_HANDLING.md](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/tests/WARNING_HANDLING.md)
- [testthat/setup.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/tests/testthat/setup.R)
- [testthat/helper-sourcing.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/tests/testthat/helper-sourcing.R)
- [testthat/helper-warnings.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/tests/testthat/helper-warnings.R)
- [testthat/test-validation.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/tests/testthat/test-validation.R)
- [testthat/test-integration.R](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/tests/testthat/test-integration.R)

### Continuous Integration (`.github/workflows/`)
- [r-cicd.yml](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/.github/workflows/r-cicd.yml)
- [release.yml](https://github.com/mkatogui/PoC_Cascade_Filtering/blob/main/.github/workflows/release.yml)
