#### Preamble ####
# Purpose: Models
# Author: Yimiao Yuan
# Date: 19 March 2024
# Contact: yymlinda.yuan@mail.utoronto.ca
# License: --
# Pre-requisites: run 01-download_data.R and 02-data_cleaning.R first to 
# get the cleaned dataset


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
clean_data <- read_csv("data/analysis_data/cleaned_ces2022.csv")

# Convert variables to factors
clean_data$race <- factor(clean_data$race)
clean_data$region <- factor(clean_data$region)

# Create voted_for variable in binary form
clean_data$voted_for_binary <- ifelse(clean_data$voted_for == "Biden", 1, 0)


# Model for n = 1000
set.seed(820)

ces2022_sample <- 
  clean_data |> 
  slice_sample(n = 1000)

election_model <-
  stan_glm(
    voted_for_binary ~ race + region,
    data = ces2022_sample,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = 
      normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 820
  )

saveRDS(
  election_model,
  file = "models/election_model.rds"
)
