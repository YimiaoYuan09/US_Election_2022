#### Preamble ####
# Purpose: Cleans the raw CES data in the data folder
# Author: Yimiao Yuan
# Date: 19 March 2024
# Contact: yymlinda.yuan@mail.utoronto.ca
# License: --
# Pre-requisites: run 01-download_data.R in scripts folder first to get the raw data
# Common Content of dataset: https://doi.org/10.7910/DVN/PR4L8P

#### Workspace setup ####
library(tidyverse)

#### Clean data ####
# read in raw data, define column type
raw_ces2022 <-
  read_csv(
    "data/raw_data/ces2022.csv",
    col_types =
      cols(
        "votereg" = col_integer(),
        "presvote20post" = col_integer(),
        "race" = col_integer(),
        "region" = col_integer()
      )
  )

# only interested in:
# respondents who are registered to vote: votereg = 1
# vote for Trump or Biden: presvote20post = 1 Biden, 2 Trump
# no NA in race, region
cleaned_ces2022 <-
  raw_ces2022 |>
  filter(votereg == 1,
         presvote20post %in% c(1, 2)) |>
  mutate(
    voted_for = if_else(presvote20post == 1, "Biden", "Trump"),
    voted_for = as_factor(voted_for),
    race = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 3 ~ "Hispanic",
      race == 4 ~ "Asian",
      race == 5 ~ "Native American",
      race == 6 ~ "Middle Eastern",
      race == 7 ~ "Two or more races",
      race == 8 ~ "Other"
    ),
    region = case_when(
      region == 1 ~ "Northeast",
      region == 2 ~ "Midwest",
      region == 3 ~ "South",
      region == 4 ~ "West"
    )
  ) |>
  select(voted_for, race, region)

#### Save data ####
write_csv(cleaned_ces2022, "data/analysis_data/cleaned_ces2022.csv")
