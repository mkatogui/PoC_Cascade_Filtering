# BasicCascadeApp

A modular Shiny app demonstrating a cascading filter system with strong input validation and a modal interface. 
R CI/CD pipeline as a working template.

---

## Features

- **Cascading Dropdowns:** Category -> Subcategory -> Product, all required.
- **Additional Inputs:** Quantity (positive integer), Comment (10-20 characters), Order Date (2023-01-01 to 2024-12-31).
- **Validation:** Real-time, with field-level feedback using `shinyFeedback`.
- **Apply Button:** Only visible when all fields are valid.
- **Reset Button:** Resets all modal fields.
- **Selections:** Displayed in the main UI with validation status.

---

## Project Structure

```
BasicCascadeApp/
├── app.R
├── launch.R           # Enhanced app launcher for deployment
├── README.md
├── shinyapps.yml      # Configuration for shinyapps.io deployment
├── R/
│   ├── data.R
│   ├── filter_module_ui.R
│   ├── filter_module_server.R
│   ├── server.R
│   ├── ui.R
│   └── validation.R
├── docs/
│   └── GITHUB_ACTIONS.md
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
4. The **Apply Filter** button appears only when all fields are valid.
5. Click **Apply Filter** to save your selections, which are then displayed in the main UI.
6. Use **Reset** to clear all fields in the modal.

---

## Validation Rules

- **Category, Subcategory, Product:** Required, must be selected in order.
- **Quantity:** Must be a positive integer.
- **Comment:** 10-20 characters.
- **Order Date:** Between 2023-01-01 and 2024-12-31.

---

## Code Quality and Modularity

- **filter_module_server.R**: Contains the server logic for the filter modal, including cascading dropdowns, validation, and summary output.
- **filter_module_ui.R**: Contains the UI for the filter modal.
- **validation.R**: All validation logic is centralized here for maintainability.
- **data.R**: Defines the sample data used for filtering.
- **ui.R** and **server.R**: Main app UI and server logic, integrating the filter module.

---

## Suggestions for Extension

- Handle cases where no data matches the filters (currently, the count is shown).
- Modularize validation feedback further if you add more fields.
- The `resetSelections` function in the filter module allows for easy external control.

---

## Testing

This project includes both unit tests and integration tests:

1. **Unit Tests**: Testing validation functions 
2. **Integration Tests**: Testing the app's UI interactions

### Running Tests

1. **Restore dependencies** (if not already done):

    ```r
    renv::restore()
    ```

2. **Run all tests**:

    From the project root directory, run:

    ```r
    testthat::test_dir("tests/testthat")
    ```

Note: Integration tests might be skipped if shinytest2 cannot find the app or if running in a non-interactive environment.

- Unit tests for validation logic are in `tests/testthat/test-validation.R`.
- Integration tests for the Shiny app are in `tests/testthat/test-integration.R`.

---

## Continuous Integration / Continuous Deployment

This project uses GitHub Actions for CI/CD to automatically:

1. **Test the app** whenever code is pushed or pull requests are made
2. **Deploy to shinyapps.io** when changes are pushed to the main branch

The CI/CD pipeline:
- Runs all unit and integration tests
- Validates the R package structure
- Automatically deploys to shinyapps.io when tests pass
- Handles compiler warnings gracefully
- Properly configures CRAN mirrors for package installation
- Uses `forceUpdate = TRUE` to update existing applications

To set up deployment, you need to configure GitHub repository secrets:
- `SHINYAPPS_NAME`: Your shinyapps.io account name
- `SHINYAPPS_TOKEN`: Your shinyapps.io token
- `SHINYAPPS_SECRET`: Your shinyapps.io secret
- `APP_NAME`: (Optional) Custom app name for deployment (defaults to 'basiccascadeapp')

See the workflow file in `.github/workflows/r-ci-cd.yml` for details.

### Deployment Configuration

This app uses a multi-tiered deployment approach:

1. **Standard deployment** via `app.R` - The primary entry point
2. **Enhanced deployment** via `deploy-app.R` - Includes more robust dependency handling
3. **Configuration-based deployment** via `shinyapps.yml` - Specifies dependencies and runtime options

The CI/CD pipeline intelligently selects the best deployment method based on the environment.

---

## CI/CD Setup

This project includes a GitHub Actions workflow for continuous integration and deployment:

- **Testing**: Automatically runs all tests in the `tests/testthat/` directory
- **Deployment**: Deploys the app to shinyapps.io when tests pass
- **Warning Handling**: Includes special handling for compiler warnings in testing
- **Git Configuration**: Properly configures Git settings to work in CI environment
- **CRAN Mirror**: Ensures package installation works properly in CI

For more details on how warnings are handled, see [Warning Handling Documentation](tests/WARNING_HANDLING.md).

For detailed information on the GitHub Actions workflow configuration, see [GitHub Actions Documentation](docs/GITHUB_ACTIONS.md).

---

## Production Readiness

This project is engineered for production, adhering to the principles of modularity, automated testing, and reproducible environments:

- **Modular Architecture**: Functional logic is separated into `R/validation.R` and Shiny modules (`filter_module_*.R`).
- **Reproducible Environment**: Uses `renv` to pin all R package versions, ensuring consistency across development and production.
- **Automated Verification**: Comprehensive test suite (unit and integration) integrated into a CI/CD pipeline.
- **CI/CD Excellence**: GitHub Actions pipeline automatically tests and deploys to `shinyapps.io` only when all checks pass.
- **Dependency Control**: `renv.lock` ensures that "it works on my machine" translates to "it works in production".

---

## License

MIT License

---
