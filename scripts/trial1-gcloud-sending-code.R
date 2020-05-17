library(keras)
library(here)
library(cloudml)
# This has been done for VGG16 but can also be adapted for xception or any other model
# Please not that after submitting each job you need to set the path to the trial-model-runs folder and then set it back to the scripts directory again in the following way:
setwd(here::here("scripts"))
getwd()
setwd(here::here("scripts/trial-model-runs"))
getwd()

# ========================================
# VGG16
cloudml_train(here::here("scripts/trial1-train-vgg16.R"), master_type = "standard_p100")
# First trial(with software and seems to be over-fitting because of accuracy of 1) --> job_collect("cloudml_2020_05_17_121925104") 
# Second trial (with sigmoid but also seems to be over-fitting) --> job_collect("cloudml_2020_05_17_124519217")

# =========================================
# DenseNet201
cloudml_train(here::here("scripts/trial1-train-densenet201.R"), master_type = "standard_p100")
# job_collect("cloudml_2020_05_17_125412295")

# =========================================
# Xception
cloudml_train(here::here("scripts/trial2-train-xception.R"), master_type = "standard_p100")
# job_collect("cloudml_2020_05_17_125721683")

# =========================================
# InceptionResNetV2
cloudml_train(here::here("scripts/trial1-train-inception_resnet_v2.R"), master_type = "standard_p100")
job_collect("cloudml_2020_05_17_131751483")

# =========================================
# NASNETLarge -->DOES NOT WORK ON THE CLOUD
cloudml_train(here::here("scripts/trial1-train-nasnetLarge.R"), master_type = "standard_p100")
# Look at jobs cloudml_2020_05_17_131243769 and cloudml_2020_05_17_132617319, the error is "Error in py_call_impl(callable, dots$args, dots$keywords) :"