# Load necessary libraries
library(tidyverse)
library(janitor)
library(lubridate)
library(here)

# Define file paths
path_data <- here::here("data/processed")        # Path to import data
path_output <- here::here("data/tables") # Path to save data

# Step 1: Load the cleaned dataset
agencies <- readRDS(file.path(path_data, "agencies_processed.rds"))
cat("Step 1: Data successfully loaded from the data folder.\n")

# Step 2: Inspect the dataset
cat("\nDataset Summary:\n")
summary(agencies)

cat("\nColumn Names:\n")
colnames(agencies) |> print()

cat("\nMissing Values in the Dataset:\n")
colSums(is.na(agencies)) |> print()

# Summarize agency counts by state
state_summary <- agencies %>%
  group_by(state) %>%
  summarise(
    total_agencies = n(),
    nibrs_adopting = sum(is_nibrs, na.rm = TRUE),  
    non_nibrs = sum(!is_nibrs, na.rm = TRUE),  
    nibrs_percent = round((nibrs_adopting / total_agencies) * 100, 2)  
  ) %>%
  ungroup()

# View state-level summary
print(state_summary)

# Summarize agency counts by type across the country
agency_type_summary <- agencies %>%
  group_by(agency_type) %>%
  summarise(
    total_agencies = n(),
    nibrs_adopting = sum(is_nibrs, na.rm = TRUE),
    non_nibrs = sum(!is_nibrs, na.rm = TRUE),
    nibrs_percent = round((nibrs_adopting / total_agencies) * 100, 2)
  ) %>%
  ungroup()

# View agency type summary
print(agency_type_summary)

# Compute nationwide statistics
national_summary <- agencies %>%
  summarise(
    total_agencies = n(),
    nibrs_adopting = sum(is_nibrs, na.rm = TRUE),
    non_nibrs = sum(!is_nibrs, na.rm = TRUE),
    nibrs_percent = round((nibrs_adopting / total_agencies) * 100, 2)
  )

# View national summary
print(national_summary)

# Summarize NIBRS adoption over the years
nibrs_timeline <- agencies %>%
  filter(is_nibrs) %>%
  group_by(year) %>%
  summarise(
    agencies_adopted = n()
  ) %>%
  ungroup() %>%
  mutate(cumulative_adoption = cumsum(agencies_adopted))  # Compute cumulative adoption

# View the summary
print(nibrs_timeline)

library(ggplot2)

library(ggplot2)

library(ggplot2)

# Identify the peak year (year with highest NIBRS adoption)
peak_year <- nibrs_timeline %>%
  filter(agencies_adopted == max(agencies_adopted))

# Create a descriptive annotation label
peak_label <- paste0("Year: ", peak_year$year, 
                     "\nNIBRS count: ", peak_year$agencies_adopted)

ggplot(nibrs_timeline, aes(x = year, y = agencies_adopted)) +
  geom_line(color = "#505078", size = 1) +
  geom_point(color = "#505078", size = 3) +  # Increase point size for visibility
  geom_text(data = peak_year, aes(label = peak_label), 
            vjust = -0.2, hjust = 0.6, color = "black", fontface = "bold", size = 3) +  # Adjust annotation position
  labs(title = "NIBRS Adoption Timeline",
       x = "Year",
       y = "Number of Agencies Adopting NIBRS") +
  theme_minimal()
