# BasicCascadeApp

A modular Shiny app demonstrating a cascading filter system with strong input validation and a modal interface.

---

## Features

- **Cascading Dropdowns:** Category → Subcategory → Product, all required.
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
├── README.md
├── R/
│   ├── data.R
│   ├── filter_module_ui.R
│   ├── filter_module_server.R
│   ├── server.R
│   ├── ui.R
│   └── validation.R
└── BasicCascadeApp.Rproj
```

---

## How to Run

1. **Install dependencies** (if needed):

    ```r
    install.packages(c("shiny", "shinyFeedback", "shinyjs", "tibble"))
    ```

2. **Run the app**:

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

## License

MIT License

---