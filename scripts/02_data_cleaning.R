# Load necessary libraries
library(tidyverse)
library(janitor)
library(lubridate)
library(here)

# Define file paths
path_data <- here::here("data/raw")        # Path to raw data
path_output <- here::here("data/processed") # Path to processed data

# Step 1: Load the raw dataset
agencies <- readRDS(file.path(path_data, "agencies_raw.rds"))
cat("Step 1: Data successfully loaded from the data folder.\n")

# Step 2: Inspect the dataset
cat("\nDataset Summary:\n")
summary(agencies)

cat("\nColumn Names:\n")
colnames(agencies) |> print()

cat("\nMissing Values in the Dataset:\n")
colSums(is.na(agencies)) |> print()

# Step 3: Check for duplicate rows
duplicate_rows <- agencies[duplicated(agencies), ]
cat("\nNumber of Fully Duplicate Rows:\n")
nrow(duplicate_rows) |> print()

# Step 4: Check for duplicate agency names
duplicate_agency_names <- agencies |>
  group_by(agency_name) |>
  summarise(count = n(), .groups = "drop") |>
  filter(count > 1)

cat("\nNumber of Duplicate Agency Names:\n")
nrow(duplicate_agency_names) |> print()

example_agency <- duplicate_agency_names$agency_name[1]  
duplicate_entries <- agencies |>
  filter(agency_name == example_agency)

cat("\nDuplicate Entries for Agency:", example_agency, "\n")
duplicate_entries |> print()

# Step 5: Remove true duplicates
agencies <- agencies |>
  distinct(ori, county, state, .keep_all = TRUE)

# Step 6: Fill missing latitude and longitude
agencies <- agencies |>
  group_by(agency_name, county, state) |>
  mutate(
    latitude = ifelse(is.na(latitude), mean(latitude, na.rm = TRUE), latitude),
    longitude = ifelse(is.na(longitude), mean(longitude, na.rm = TRUE), longitude)
  ) |>
  ungroup()

# Step 7: Calculate county centroids
county_centroids <- agencies |>
  filter(!county %in% c("NOT SPECIFIED", "Unknown") & !is.na(county)) |>
  group_by(county, state) |>
  summarise(
    county_latitude = mean(latitude, na.rm = TRUE),
    county_longitude = mean(longitude, na.rm = TRUE),
    .groups = "drop"
  )

# Step 8: Merge county centroids
agencies <- agencies |>
  left_join(county_centroids, by = c("county", "state")) |>
  mutate(
    latitude = ifelse(is.na(latitude), county_latitude, latitude),
    longitude = ifelse(is.na(longitude), county_longitude, longitude)
  ) |>
  select(-county_latitude, -county_longitude)

# Step 9: Calculate state centroids
state_centroids <- agencies |>
  filter(!is.na(latitude) & !is.na(longitude)) |>
  group_by(state) |>
  summarise(
    state_latitude = mean(latitude, na.rm = TRUE),
    state_longitude = mean(longitude, na.rm = TRUE),
    .groups = "drop"
  )

# Step 10: Merge state centroids
agencies <- agencies |>
  left_join(state_centroids, by = "state") |>
  mutate(
    latitude = ifelse(is.na(latitude), state_latitude, latitude),
    longitude = ifelse(is.na(longitude), state_longitude, longitude)
  ) |>
  select(-state_latitude, -state_longitude)

# Step 11: Verify results
cat("\nMissing Values After Cleaning:\n")
colSums(is.na(agencies)) |> print()

# Step 12: Handle missing agency types
missing_agency_type <- agencies |>
  filter(is.na(agency_type))

cat("Number of missing agency types:\n")
nrow(missing_agency_type) |> print()

cat("\nExamples of missing agency types:\n")
missing_agency_type |> slice_sample(n = 10) |> print()

agency_type_freq <- agencies |>
  group_by(agency_type) |>
  summarise(count = n(), .groups = "drop") |>
  arrange(desc(count))

cat("\nFrequency of each agency type:\n")
agency_type_freq |> print()

agency_type_examples <- agencies |>
  group_by(agency_type) |>
  slice_sample(n = 30)

cat("\nExamples of each agency type:\n")
agency_type_examples |> print()

# Step 13: Standardize agency_type
agencies <- agencies |>
  mutate(agency_type = case_when(
    grepl("Police Department", agency_name, ignore.case = TRUE) ~ "City",
    grepl("County Sheriff's Office", agency_name, ignore.case = TRUE) ~ "County",
    grepl("State Police|State Patrol|Highway Patrol", agency_name, ignore.case = TRUE) ~ "State Police",
    grepl("State Park|State Fire", agency_name, ignore.case = TRUE) ~ "Other State Agencies",
    grepl("Tribal", agency_name, ignore.case = TRUE) ~ "Tribal",
    grepl("University|College", agency_name, ignore.case = TRUE) ~ "University or College",
    agency_type %in% c("Other State Agency", "Other") ~ "Other State Agencies",
    TRUE ~ "Other State Agencies"
  ))

# Step 14: Extract the year from nibrs_start_date
agencies <- agencies |>
  mutate(year = year(nibrs_start_date))

# Step 15: Verify the results
cat("\nFirst few rows with the new 'year' column:\n")
agencies |> 
  select(state, agency_type, is_nibrs, nibrs_start_date, year) |>
  head() |>
  print()

# Step 16: Handle NIBRS Reporting Mismatches
## Inspecting inconsistencies between is_nibrs and nibrs_start_date
nibrs_mismatch_false <- agencies |>
  filter(is_nibrs == FALSE & !is.na(nibrs_start_date))

nibrs_mismatch_true <- agencies |>
  filter(is_nibrs == TRUE & is.na(nibrs_start_date))

cat("\nStep 16: Inspecting NIBRS inconsistencies...\n")
cat("Mismatched cases where is_nibrs = FALSE but nibrs_start_date is present:", nrow(nibrs_mismatch_false), "\n")
cat("Mismatched cases where is_nibrs = TRUE but nibrs_start_date is missing:", nrow(nibrs_mismatch_true), "\n")

# Correct the entries by setting is_nibrs to TRUE for agencies with a valid nibrs_start_date
agencies <- agencies |>
  mutate(is_nibrs = ifelse(!is.na(nibrs_start_date), TRUE, is_nibrs))


# Step 17: Save the processed data
saveRDS(agencies, file.path(path_output, "agencies_processed.rds"))
cat("\nStep 18: Processed data successfully saved to the output folder.\n")

# Step 18: Final dataset summary
cat("\nFinal Dataset Summary:\n")
summary(agencies)