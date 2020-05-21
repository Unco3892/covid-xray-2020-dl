library(keras)
library(tfruns)
library(here)
library(cloudml)
# library(tidyverse)
# library(kableExtra)

# Change the working directory
setwd(here::here("scripts/multiclass/vgg16/"))
 
 
# The tuning will take place on the cloud
cloudml_train(
  file = "train-COVID-mc_vgg16.R",
  config = "tuning_mc_1.yml"
)

# Setting the path for collecting the files vgg16 binary files
setwd(here("runs/multiclass/vgg16"))
getwd()
# Collecting the final hyperparamter tuning (this id refers to the hyperparameter tuning of vgg16 binary files)
job_collect("cloudml_2020_05_21_140508986", trials = "all")

# Show the runs and sort them based on accuracy
runs_vgg16 <- ls_runs(runs_dir = here("scripts/multiclass/vgg16/runs")) #it could also be categorical


View(runs_vgg16)
runs_report <- runs %>% select(metric_acc, metric_val_acc,metric_loss,metric_val_loss,flag_lr, epochs_completed, flag_dropoutrate,flag_reg, flag_units1, flag_units2, flag_optimizer,flag_activation, cloudml_state, run_dir) %>% arrange(desc(metric_val_acc), metric_val_loss) %>% kable() %>% kable_styling(bootstrap_options = "striped",full_width = F,position = "center")

# Viewing the best runs
view_run(here::here("runs/multiclass/vgg16/runs/")) # The first one drops to almost 40% at one point so it is not good
view_run(here::here("runs/multiclass/vgg16/runs/"))



