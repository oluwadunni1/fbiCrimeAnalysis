# FBI Crime Analysis: NIBRS Adoption Project
This repository contains an analysis that examines the adoption of the National Incident-Based Reporting System (NIBRS) across U.S. law enforcement agencies. This project was part of [TidyTuesday](https://github.com/rfordatascience/tidytuesday), a weekly social data project, for February 18, 2025. The dataset was sourced from the TidyTuesday repository for that week : [TidyTuesday 2025/02/18](https://github.com/rfordatascience/tidytuesday/tree/master/data/2025/2025-02-18).

## Final Report 

[View the FBI Crime Analysis Report](https://oluwadunni1.github.io/fbiCrimeAnalysis/).- A comprehensive analysis of NIBRS adoption across U.S. law enforcement agencies, examining nationwide trends, regional disparities, and state-level challenges.


## Project Structure

-   **data/**: Data files
    -   `raw/`: Original data files.
    -   `processed/`: Cleaned data files.
-   **scripts/**: R scripts for data import, cleaning, and analysis.
    -   `01_data_import.R`: Imports the raw data.
    -   `02_data_cleaning.R`: Cleans the data for analysis.
    -   `03_analysis.R`: Performs analysis (summary tables, charts).
-   **docs/**: Documentation, Quarto report, and visuals.
    -   `metadata.md`: Describes the rationale for data cleaning steps.
    -   `FBI_crime_analysis.qmd`: Quarto source file for the report.
    -   `index.html`: Rendered HTML report.
    -   `region.png`, `state_adoption_map.png`: Tableau visuals.
    -   `fbi_crime_analysis_files/`: Auto-generated folder containing resources (e.g., plot images) for the HTML.
-   **output/**: Rendered outputs from analysis script.
    -   `tables/`: Table outputs (CSV).
    -   `visuals/`: Plot outputs (PNG).

## How to Use
1. [View the Final Report](https://oluwadunni1.github.io/fbiCrimeAnalysis/).  
2.  Clone the repository:  `git clone`  [https://github.com/oluwadunni1/fbiCrimeAnalysis.git](https://github.com/oluwadunni1/fbiCrimeAnalysis.git)
3.  To reproduce the report:
    -   Ensure R and Quarto are installed.
    -   Run the scripts in order (`scripts/01_data_import.R` → `scripts/02_data_cleaning.R` → `scripts/03_analysis.R`).
    -   Render the Quarto report: `quarto render docs/FBI_crime_analysis.qmd --to html`

## Requirements

-   R (version 4.0 or higher)
-   Quarto
-   R packages: `tidyverse`, `gt`, `scales`, `knitr`, `ggplot2`, `lubridate`, `ggthemes`, `kableExtra`

## Author

Oluwadunni  
Dunnioluajayi@gmail.com
