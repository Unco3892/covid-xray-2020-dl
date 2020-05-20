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
# job_collect("cloudml_2020_05_18_145238086", trials = "all")

# Show the runs and sort them based on accuracy
runs <- ls_runs(runs_dir = here::here("runs/binary/vgg16/runs")) #it could also be categorical
# View(runs)

runs_report <-
  runs %>% select(3, 5, 2, 4, 6:12, cloudml_state, run_dir) %>% arrange(desc(metric_val_categorical_accuracy), metric_val_loss) %>% kable() %>% kable_styling(
    bootstrap_options = "striped",
    full_width = F,
    position = "center"
  )

# REQUIRES CHANGE AND CONTROL

# Viewing the first run
view_run(here::here("runs/binary/vgg16/runs/cloudml_2020_05_18_145238086-106")) # The first drops one to 40% which is not so desirable

# Viewing the second run
view_run(here::here("runs/binary/vgg16/runs/cloudml_2020_05_18_145238086-054")) # THIS IS A GREAT RUN

# Comparing the third and foruth run
compare_runs(
  runs = c(
    here::here("runs/binary/vgg16/runs/cloudml_2020_05_18_145238086-014"), # This run is also great but not as good as the second run
    here::here("runs/binary/vgg16/runs/cloudml_2020_05_18_145238086-126")  # Not a good run
  )
) # A competitor for the 2nd best run is the 3rd run and the only difference between the two is the optimizer and the learning rate.

#  Comparing the fifth and the sixth run
compare_runs(
  runs = c(
    here::here("runs/binary/vgg16/runs/cloudml_2020_05_18_145238086-125"),
    here::here("runs/binary/vgg16/runs/cloudml_2020_05_18_145238086-117")
  )
) # 6th run is much more stable because of the optimizer adamax

# CONCLUSION: TAKE THE 2ND RUN AND THE 3RD ONE. USE ADAMAX OPTIMIZER

