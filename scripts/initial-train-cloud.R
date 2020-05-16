library(keras)
library(here)
library(cloudml)


# Training on the cloud
cloudml_train(here::here("scripts/trial-train-COVID-binary.R"), master_type = "standard_p100")

# Setting the path for downloading the files
setwd("runs")

# Collecting the final re-train model and placing the model in the "results" folder
job_collect("-")


install.packages("reticulate")
library(reticulate)
install_miniconda()
install.packages("keras")
library(keras)
install_keras(method = "conda")
