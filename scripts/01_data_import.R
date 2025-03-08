library(readr)
library(dplyr)
library(here)

path_output <- here::here("data/raw")

agencies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-02-18/agencies.csv')

head(agencies)
str(agencies)

saveRDS(agencies, file.path(path_output, "agencies_raw.rds"))

cat("Data imported successfully and saved as RDS.\n")
