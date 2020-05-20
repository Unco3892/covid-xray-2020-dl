library(keras)
library(tfruns)
library(here)
library(cloudml)
library(tidyverse)
library(kableExtra)

# Change the working directory

setwd(here::here("scripts/binary/densenet201/"))

# The tuning will take place on the cloud
cloudml_train(file = "train-COVID-binary.R",
              config = "tuning_binary_dense1.yml")


# Setting the path for collecting the files
setwd(here::here("runs/binary/densenet201"))
getwd()

# Collecting the final hyperparamter tuning for densenet201 binary
job_collect("cloudml_2020_05_20_141743560", trials = "all")

# Show the runs and sort them based on accuracy
runs <- ls_runs(runs_dir = here("runs/binary/densenet201/runs"))

runs_report <-
  runs %>% select(3, 5, 2, 4, 6:12, cloudml_state, run_dir) %>% arrange(desc(metric_val_categorical_accuracy), metric_val_loss) %>% kable() %>% kable_styling(
    bootstrap_options = "striped",
    full_width = F,
    position = "center"
  )

view_run(here::here(
  "runs/binary/densenet201/runs/cloudml_2020_05_20_141743560-080"
)) # The first one is definitly not good as it drops very low.

# Comparing the second and third run
compare_runs(runs = c(
  here::here(
    "runs/binary/densenet201/runs/cloudml_2020_05_20_141743560-085"
  ),
  here::here(
    "runs/binary/densenet201/runs/cloudml_2020_05_20_141743560-050"
  )
)) # The third run looks good


# Comparing fourth and fifth run
compare_runs(runs = c(
  here::here(
    "runs/binary/densenet201/runs/cloudml_2020_05_20_141743560-090"
  ),
  here::here(
    "runs/binary/densenet201/runs/cloudml_2020_05_20_141743560-122"
  )
)) # Neither of these runs is good

# CONCLUSION: TAKE THE 3RD RUN with id cloudml_2020_05_20_141743560-050
