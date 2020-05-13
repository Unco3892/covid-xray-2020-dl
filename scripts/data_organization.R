library(tidyverse)
library(here)
library(stringi)
library(stringr)
library(keras)
library(tfruns)

# ========
# Chestxray
# ========
# First we do a small eda analysis
# Import the data
data_covid19 <-read.csv(here::here("data/chestxray_COVID/metadata.csv"))

# Number of total patients with all diseases (198 persons)
data_covid19 %>% count(patientid) %>% nrow()

# Number of total patients with COVID+ (160 persons), some of these are CT scans and not X-rays
data_covid19 %>% filter(finding== "COVID-19") %>%  count(patientid) %>% nrow()
# We do not care about the patients but rather images which could be a replacement to data augmentation.

# Number of total patients with COVID+ (160 persons), some of these are CT scans and not X-rays and also includes multiples angles of the x-ray scan
data_covid19 %>% filter(finding== "COVID-19") %>%  count(patientid) %>% nrow()

# Number of x-rays we have of COVID+ (142 instances) in all the views
data_covid19 %>% filter(finding== "COVID-19" & modality== "X-ray") %>% nrow()

# WHAT WE WILL USE: Number of x-rays we have of COVID+ PA angle (140 instances)
only_covid <- data_covid19 %>% filter(finding== "COVID-19" & modality== "X-ray" & view=="PA")
filestocopy <- as.vector(only_covid$filename)

# ~~~~
# After having finished the eda, we come across moving the files to a new folder aclled final_data/COVID+

# Set both the directory to take the images as well as the target directory
org_dir <- here::here("data/chestxray_COVID/images")
target_dir <- here::here("data/final_data/COVID+")

# Finally we copy the files from the only_covid cases
lapply(filestocopy, function(x) file.copy(paste (org_dir, x , sep = "/"),paste (target_dir,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

# ======================================
# Kermany datasetpart 1  (take the normal cases)
# ======================================
# Sampling Images from the kermany data for normal to have a balanced dataset

# Set both the directory to take the images as well as the target directory for negative COVID cases
org_dir2 <- here::here("data/kermany_OTHERS/chest_xray/train/NORMAL")
target_dir2 <- here::here("data/final_data/COVID-")

# Now list the files
jpeg2 <- list.files(org_dir2, pattern = ".jpeg")

# We randomly take the same number photos as the COVID+
set.seed(5)
filestocopy2 <- as.vector(sample(jpeg2, nrow(only_covid)))

# Finally we copy the files as in the previous case
lapply(filestocopy2, function(x) file.copy(paste (org_dir2, x , sep = "/"),paste (target_dir2,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

# =======================================
# Kermany dataset part 2 (Pneumonia VIRAL)
# =======================================
# Sampling Images from the kermany data for VIRAL pneumonia to have a balanced dataset

# Set both the directory to take the images as well as the target directory for negative COVID cases
org_dir3 <- here::here("data/kermany_OTHERS/chest_xray/train/PNEUMONIA")
target_dir3 <- here::here("data/final_data/Pneumonia_viral")

# Now list the files
jpeg3 <- list.files(org_dir3, pattern = "VIRUS")

# We randomly take the same number photos as the COVID+
set.seed(5)
filestocopy3 <- as.vector(sample(jpeg3, nrow(only_covid)))

# Finally we copy the files as in the previous case
lapply(filestocopy3, function(x) file.copy(paste (org_dir3, x , sep = "/"),paste (target_dir3,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))

# ============================================
# Kermany dataset part 2 (Pneumonia BACTERIAL)
# ============================================
# Sampling Images from the kermany data for BACTERIAL pneumonia to have a balanced dataset

# Set both the directory to take the images as well as the target directory for negative COVID cases
org_dir4 <- here::here("data/kermany_OTHERS/chest_xray/train/PNEUMONIA")
target_dir4 <- here::here("data/final_data/Pneumonia_bacterial")

# Now list the files
jpeg4 <- list.files(org_dir4, pattern = "BACTERIA")

# We randomly take the same number photos as the COVID+
set.seed(5)
filestocopy4 <- as.vector(sample(jpeg4, nrow(only_covid)))

# Finally we copy the files as in the previous case
lapply(filestocopy4, function(x) file.copy(paste (org_dir4, x , sep = "/"),paste (target_dir4,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE))