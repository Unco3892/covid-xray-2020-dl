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
  file = "train-COVID-mc.R",
  config = "tuning_mc_den.yml"
)

# Setting the path for collecting the files
setwd(here("runs/multiclass/densenet201"))
getwd()

# Collecting the final hyperparamter tuning
job_collect("-", trials = "all")

# Show the runs and sort them based on accuracy
runs <- ls_runs(runs_dir = here("scripts/runs/binary")) #it could also be categorical

runs_report <-
  runs %>% filter(cloudml_job == "-") %>% select(flag_lr,
                                                 metric_acc,
                                                 metric_val_acc,
                                                 metric_loss,
                                                 metric_val_loss,
                                                 completed) %>% arrange(desc(metric_val_acc)) %>% kable() %>% kable_styling(bootstrap_options = "striped",full_width = F,position = "center")

# Only if needed to do a second tuning
# cloudml_train(file="train-natural-lenet-5.R",
#               config = "tuning_ex2_final_2.yml")

# Collecting the job
setwd(here("runs"))
job_collect("-", trials = "all")
