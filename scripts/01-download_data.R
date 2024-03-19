#### Preamble ####
# Purpose: Downloads and saves the data from 2022 Cooperative Election Study (CES)
# Author: Yimiao Yuan
# Date: 18 March 2024
# Contact: yymlinda.yuan@mail.utoronto.ca
# License: --
# Pre-requisites: --
# CES website:  https://doi.org/10.7910/DVN/PR4L8P


#### Workspace setup ####
library(dataverse)
library(tidyverse)


#### Download data ####
raw_ces2022 <-
  get_dataframe_by_name(
    filename = "CCES22_Common_OUTPUT_vv_topost.csv",
    dataset = "10.7910/DVN/PR4L8P",
    server = "dataverse.harvard.edu",
    .f = read_csv
  )

raw_ces2022 <-
  raw_ces2022 |>
  select(votereg, presvote20post, race, region)


#### Save data ####
write_csv(raw_ces2022, "data/raw_data/ces2022.csv")
