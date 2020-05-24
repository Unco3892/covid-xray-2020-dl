library(keras)
library(tfruns)
library(here)
library(cloudml)
# library(tidyverse)
# library(kableExtra)

# Change the working directory

setwd(here::here("scripts/multiclass/densenet201/"))

# The tuning will take place on the cloud
cloudml_train(
  file = "train-COVID-mc_den.R",
  config = "tuning_mc_den.yml"
)

# Setting the path for collecting the files
setwd(here::here("runs/multiclass/densenet201"))
getwd()

# Collecting the final hyperparamter tuning
job_collect("cloudml_2020_05_22_210439612", trials = "all")

# Show the runs and sort them based on accuracy
runs_den201 <- ls_runs(runs_dir = here("runs/multiclass/densenet201/runs")) #it could also be categorical


View(runs_den201)


runs_report <-
  runs %>% filter(cloudml_job == "cloudml_2020_05_22_210439612") %>% select(flag_lr,
                                                 metric_acc,
                                                 metric_val_acc,
                                                 metric_loss,
                                                 metric_val_loss,
                                                 completed) %>% arrange(desc(metric_val_acc)) %>% kable() %>% kable_styling(bootstrap_options = "striped",full_width = F,position = "center")


# cloudml_train(file="train-natural-lenet-5.R",
#               config = "tuning_ex2_final_2.yml")

# Collecting the job
setwd(here("runs"))
job_collect("-", trials = "all")
