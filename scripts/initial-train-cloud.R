library(keras)
library(here)
library(cloudml)


# Training on the cloud
cloudml_train(here::here("scripts/train-COVID-binary.R"), master_type = "standard_p100")

# Setting the path for downloading the files
setwd("runs")

# Collecting the final re-train model and placing the model in the "results" folder
job_collect("-")


