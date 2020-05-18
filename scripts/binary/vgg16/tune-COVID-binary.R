library(keras)
library(tfruns)
library(here)
library(cloudml)
# library(tidyverse)
# library(kableExtra)

# Change the working directory
# setwd("tune-cloud")

# The tuning will take place on the cloud
cloudml_train(
  file = here::here("scripts/binary/vgg16/train-COVID-binary.R"),
  config = here::here("scripts/binary/vgg16/tuning_binary_1.yml")
)

# Setting the path for collecting the files vgg16 binary files
setwd(here("runs/binary/vgg16"))
getwd()
# Collecting the final hyperparamter tuning (this id refers to the hyperparameter tuning of vgg16 binary files)
job_collect("cloudml_2020_05_17_172621619", trials = "all")

# Show the runs and sort them based on accuracy
runs <- ls_runs(runs_dir = here::here("runs/binary/vgg16/runs")) #it could also be categorical

View(runs)
runs_report <- runs %>% select(metric_acc, metric_val_acc,metric_loss,metric_val_loss,flag_lr, epochs_completed, flag_dropoutrate,flag_reg, flag_units1, flag_units2, flag_optimizer,flag_activation, cloudml_state, run_dir) %>% arrange(desc(metric_val_acc), metric_val_loss) %>% kable() %>% kable_styling(bootstrap_options = "striped",full_width = F,position = "center")

# Viewing the best runs
view_run(here::here("runs/binary/vgg16/runs/cloudml_2020_05_17_172621619-089")) # The first one drops to almost 40% at one point so it is not good

# Comparing the second and third run
compare_runs(
  runs = c(
    here::here("runs/binary/vgg16/runs/cloudml_2020_05_17_172621619-059"), # should be modified
  here::here("runs/binary/vgg16/runs/cloudml_2020_05_17_172621619-057")  # should be modified
  )
) # The run ending with 057 drops to almost 40% at one point so it is not good and the second run (cloudml_2020_05_17_172621619-059) is definitly the best run so far, you can view the run below
# view_run(here::here("runs/binary/vgg16/runs/cloudml_2020_05_17_172621619-057")) 


#  Comparing the fourth and the fifth run
compare_runs(
  runs = c(
    here::here("runs/binary/vgg16/runs/cloudml_2020_05_17_172621619-027"), # should be modified
    here::here("runs/binary/vgg16/runs/cloudml_2020_05_17_172621619-122")  # should be modified
  )
) # The run ending with 027 also seems to be good like the last one however the fifth like just like the third run seems to fall drastically and should be ignored.


