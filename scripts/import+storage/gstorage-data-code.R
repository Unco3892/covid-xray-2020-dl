library(keras)
library(here)
library(cloudml)

# Placing all the data on the storage.

# gs_copy(
#   source = here::here("data/final_data/"),
#   destination = "gs://covid-pw2/",
#   recursive = TRUE
# )

# Change the path after uplading the files
setwd(here("scripts"))

# File for the final re-training for learning rates
# cloudml_train(file="-",
#               master_type = "-", 
#               region = "-")
