# Data Cleaning Metadata

## Overview

This document explains the rationale behind the data cleaning steps applied to the `agencies` dataset. The goal of the cleaning process is to ensure the dataset is consistent, accurate, and ready for analysis.

------------------------------------------------------------------------

## Cleaning Steps

### 1. **Loading the Dataset**

-   The dataset is loaded from the `data/raw` folder using `readRDS`.

### 2. **Initial Inspection**

-   The dataset is inspected for missing values, column names, and summary statistics to identify potential issues.

### 3. **Handling Duplicates**

-   **Fully Duplicate Rows**: Rows with identical values across all columns are removed.
-   **Duplicate Agency Names**: Agencies with duplicate names but different metadata (e.g., ORIs, counties, or states) are identified and inspected.

### 4. **Removing True Duplicates**

-   Rows with the same `ori`, `county`, and `state` values are removed to ensure each agency is represented only once.

### 5. **Filling Missing Coordinates**

-   Missing latitude and longitude values are imputed using the following hierarchy:
    1.  Mean coordinates of other agencies with the same name, county, and state.
    2.  County centroids (mean coordinates of all agencies in the same county and state).
    3.  State centroids (mean coordinates of all agencies in the same state).

### 6. **Standardizing Agency Types**

-   The `agency_type` column is standardized based on patterns in the `agency_name` column:
    -   Specific patterns (e.g., "Police Department" → "City") are used to classify agencies.
    -   "Other State Agency" and "Other" are merged into a single category called "Miscellaneous".
    -   Entries with "Unknown" or non-matching patterns are classified as "Miscellaneous".

### 7. **Extracting the Year**

-   The `year` column is extracted from the `nibrs_start_date` column to enable trend analysis over time.

### 8. **Fixing Mismatched NIBRS Data**

-   I noticed some inconsistencies between the `is_nibrs` column (which shows if an agency participates in NIBRS) and the `nibrs_start_date` column (which records when they started reporting). Specifically:

    -   Some agencies were marked as `FALSE` for `is_nibrs` but had a `nibrs_start_date`. That didn’t make sense!

    -   I fixed this by setting `is_nibrs` to `TRUE` for any agency with a valid `nibrs_start_date`. Now the data makes way more sense.

### 9. **Saving the Processed Data**

-   The cleaned dataset is saved to the `data/processed` folder for future analysis.

------------------------------------------------------------------------

## Rationale for Key Decisions

### **Merging "Other State Agency" and "Other"**

-   These categories were merged into "Miscellaneous" to simplify the dataset and reduce ambiguity. Both categories served as catch-alls for agencies that didn't fit into the main categories.

### **Handling Missing Coordinates**

-   A hierarchical approach was used to impute missing coordinates to ensure the dataset remains as complete as possible without introducing significant bias.

### **Standardizing Agency Types**

-   Patterns in agency names were used to reclassify `agency_type` to ensure consistency and accuracy. This approach minimizes manual effort and ensures scalability for larger datasets.

### **Fixing Mismatched NIBRS Data**

-   The mismatched `is_nibrs` and `nibrs_start_date` columns were causing confusion. By setting `is_nibrs` to `TRUE` for any agency with a valid `nibrs_start_date`, I made sure the data reflects reality.

### **Extracting the Year**

-   Extracting the year from `nibrs_start_date` enables trend analysis over time,like how NIBRS adoption has changed over the years

------------------------------------------------------------------------

## Output

The cleaned dataset is saved to the `data/processed` folder, ready for analysis.
