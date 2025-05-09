# Modularized Cascade Filter Shiny App

## Overview
This Shiny application demonstrates a modularized cascade filter system with a modal interface. The app allows users to filter data through a hierarchical selection process (Category → Subcategory → Product) and requires additional information (Quantity, Comment, Order Date) with strict validation rules. The UI and server logic are fully modularized for maintainability.

## Features
- Cascading dropdowns: Selections in one dropdown affect the next
- Modal-based filter interface
- **Required fields**: All filter and input fields must be filled and valid to enable the Apply button
- **Validation**:
  - Quantity: Must be a positive number
  - Comment: Must be between 10 and 20 characters
  - Order Date: Must be between 2023-01-01 and 2024-12-31
  - Category, Subcategory, Product: All must be selected
- Real-time feedback using `shinyFeedback` (fields highlight errors)
- The "Apply Filter" button only appears when all fields are valid
- Modularized code structure for easy maintenance

## Project Structure
```
BasicCascadeApp/
├── app.R                 # Main application entry point
├── BasicCascadeApp.Rproj # RStudio project file
├── README.md             # This documentation file
└── R/
    ├── data.R            # Sample data creation and loading
    ├── filter_module.R   # Filter UI and server module
    ├── server.R          # Main app server logic
    ├── ui.R              # Main app UI components
    └── validation.R      # All validation logic for the app
```

## How to Run
1. Open the project in RStudio by double-clicking the `BasicCascadeApp.Rproj` file
2. Open the `app.R` file
3. Click the "Run App" button in RStudio, or run the following in the R console:
   ```r
   shiny::runApp()
   ```

## How It Works
1. Click the "Open Filter" button to open the modal dialog
2. Select a Category, Subcategory, and Product (all required)
3. Enter a positive Quantity, a Comment (10-20 characters), and select a valid Order Date
4. The "Apply Filter" button will only appear when all fields are valid
5. Real-time feedback is shown for each field if invalid
6. Click "Apply Filter" to save your selections and close the modal
7. Your selections and their validation status are displayed in the main app view

## Dependencies
- shiny
- tidyverse
- shinyFeedback
- shinyjs

## Development
- All validation logic is in `R/validation.R`
- UI and server logic for the filter modal are in `R/filter_module.R`
- Main app UI and server logic are in `R/ui.R` and `R/server.R`

To change validation rules, edit the functions in `R/validation.R`.

## Troubleshooting

### Error: could not find function "tibble"
If you see an error like:

```
Error in tibble(Category = ...) : could not find function "tibble"
```

This means the `tibble` package is not loaded on the server. To fix this, add the following line at the top of your `R/data.R` file:

```r
library(tibble)
```

Also, make sure all dependencies are listed in your app and are installed on your deployment server. If you use `tidyverse`, you may also want to explicitly load `library(tidyverse)` or the specific packages you use (e.g., `library(dplyr)`, `library(tibble)`).

If deploying to shinyapps.io, all packages used in any R script must be loaded with `library()` in your code.

---

**Note:** The "Apply Filter" button will only appear when all required fields are filled and valid. This is enforced using only R code and the `shinyjs` and `shinyFeedback` packages for a robust, user-friendly experience.
