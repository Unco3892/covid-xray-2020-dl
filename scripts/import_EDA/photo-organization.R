library(tidyverse)
library(here)

# ===============================
# chestxray: COVID Positive cases
# ===============================
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
# We do 80-20 for train and test
filestocopy_pos_train <- as.vector(only_covid$filename)[1:112]
filestocopy_pos_test <- as.vector(only_covid$filename)[113:140]

# ~~~~
# After having finished the eda, we come across moving the files to a new folder aclled final_data/COVID+
# ~~~~
# Set both the directory to take the images as well as the target directory
org_dir_positive <- here::here("data/chestxray_COVID/images")
tar_dir_pos_train<- here::here("data/final_data/train/COVID+")
tar_dir_post_test<- here::here("data/final_data/test/COVID+")

# We copy the files for the train (COVID+)
lapply(filestocopy_pos_train, function(x) file.copy(paste (org_dir_positive, x , sep = "/"),paste (tar_dir_pos_train,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))

# We copy the files for the test (COVID+)
lapply(filestocopy_pos_test, function(x) file.copy(paste (org_dir_positive, x , sep = "/"),paste (tar_dir_post_test,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))

# =============================
# Kermany dataset: Normal cases
# =============================
# Sampling Images from the kermany data for normal to have a balanced dataset
# Set both the directory to take the images as well as the target directory for negative COVID cases
org_dir_negative <- here::here("data/kermany_OTHERS/chest_xray/train/NORMAL")
tar_dir_neg_train <- here::here("data/final_data/train/COVID-")
tar_dir_neg_test<- here::here("data/final_data/test/COVID-")

# Now list the files
jpeg2 <- list.files(org_dir_negative, pattern = ".jpeg")

# We randomly take the same number photos as the COVID+ and then divide them into train and test
set.seed(5)
all_negatives <- as.vector(sample(jpeg2, nrow(only_covid)))
filestocopy_neg_train <- all_negatives[1:112]
filestocopy_neg_test <- all_negatives[113:140]

# We copy the files for the train (COVID-)
lapply(filestocopy_neg_train, function(x) file.copy(paste (org_dir_negative, x , sep = "/"),paste (tar_dir_neg_train,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))

# We copy the files for the test (COVID-)
lapply(filestocopy_neg_test, function(x) file.copy(paste (org_dir_negative, x , sep = "/"),paste (tar_dir_neg_test,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))

# ======================================
# Kermany dataset: Pneumonia VIRAL cases
# ======================================
# Sampling Images from the kermany data for VIRAL pneumonia to have a balanced dataset

# Set both the directory to take the images as well as the target directory for negative COVID cases
org_dir_viral <- here::here("data/kermany_OTHERS/chest_xray/train/PNEUMONIA")
tar_dir_vir_train <- here::here("data/final_data/train/Pneumonia_viral")
tar_dir_vir_test <- here::here("data/final_data/test/Pneumonia_viral")

# Now list the files
jpeg3 <- list.files(org_dir_viral, pattern = "VIRUS")

# We randomly take the same number photos as the COVID+
set.seed(5)
all_virus <- as.vector(sample(jpeg3, nrow(only_covid)))
filestocopy_vir_train <- all_virus[1:112]
filestocopy_vir_test<- all_virus[113:140]

# We copy the files for the train (VIRAL +)
lapply(filestocopy_vir_train, function(x) file.copy(paste (org_dir_viral, x , sep = "/"),paste (tar_dir_vir_train,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))

# We copy the files for the test (VIRAL +)
lapply(filestocopy_vir_test, function(x) file.copy(paste (org_dir_viral, x , sep = "/"),paste (tar_dir_vir_test,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))

# ====================================
# Kermany dataset: Pneumonia BACTERIAL
# ====================================
# Sampling Images from the kermany data for BACTERIAL pneumonia to have a balanced dataset

# Set both the directory to take the images as well as the target directory for negative COVID cases
org_dir_bac <- here::here("data/kermany_OTHERS/chest_xray/train/PNEUMONIA")
tar_dir_bac_train <- here::here("data/final_data/train/Pneumonia_bacterial")
tar_dir_bac_test <- here::here("data/final_data/test/Pneumonia_bacterial")

# Now list the files
jpeg4 <- list.files(org_dir_bac, pattern = "BACTERIA")

# We randomly take the same number photos as the COVID+
set.seed(5)
all_bacteria <- as.vector(sample(jpeg4, nrow(only_covid)))
filestocopy_bac_train <- all_bacteria[1:112]
filestocopy_bac_test<- all_bacteria[113:140]

# Finally, we once again copy the files for the train (BACTERIAL +)
lapply(filestocopy_bac_train, function(x) file.copy(paste (org_dir_bac, x , sep = "/"),paste (tar_dir_bac_train,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))

# We do the same for the train set of (BACTERIAL +)
lapply(filestocopy_bac_test, function(x) file.copy(paste (org_dir_bac, x , sep = "/"),paste (tar_dir_bac_test,x, sep = "/"), recursive = FALSE,  copy.mode = TRUE, overwrite = TRUE))