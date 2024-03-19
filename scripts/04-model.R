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

# Create voted_for variable in binary form
clean_data$voted_for_binary <- ifelse(clean_data$voted_for == "Biden", 1, 0)


# Model for n = 1000
set.seed(820)

ces2022_sample <- 
  clean_data |> 
  slice_sample(n = 1000)

# Logistic model
logistic_model <-
  stan_glm(
    voted_for_binary ~ race,
    data = ces2022_sample,
    family = binomial(link = "logit"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 820
  )

saveRDS(
  logistic_model,
  file = "models/logistic_model.rds"
)

# Poisson Model
poisson_model <-
  stan_glm(
    voted_for_binary ~ race,
    data = ces2022_sample,
    family = poisson(link = "log"),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 820
  )

saveRDS(
  poisson_model,
  file = "models/poisson_model.rds"
)

# Negative binomial regression
neg_bio_model <-
  stan_glm(
    voted_for_binary ~ race,
    data = ces2022_sample,
    family = neg_binomial_2(link = "log"),
    seed = 820
  )

saveRDS(
  neg_bio_model,
  file = "models/neg_bio_model.rds"
)
