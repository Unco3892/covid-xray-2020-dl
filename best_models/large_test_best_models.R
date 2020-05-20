library(keras)
library(cloudml)
library(tfruns)
library(kerasR)


# ------------------------------------
generator <-
  image_data_generator(
    rescale = 1 / 255,
    validation_split = 0.5,
    zoom_range = 0.2
  )

generator_test <-
  image_data_generator(
    rescale = 1 / 255
  )

# Import images
# ------------------------------------
train <- flow_images_from_directory(
  #directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  directory = here::here("data/final_data/binary/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "training", 
  #shuffle = T 
)

valid <- flow_images_from_directory(
  #directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  directory = here::here("data/final_data/binary/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "validation", 
  #shuffle = T 
)

large_test <- flow_images_from_directory(
  #directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/test"),
  directory = here::here("data/binary_large_test/"),
  target_size = c(224, 224),
  generator = generator_test,
  batch_size = 16, 
  #shuffle = T
)



#-----------------------------------------------------#
#Evaluate model1
model1 <- load_model_hdf5("best_models/my_model_cloudml_2020_05_18_145238086-112.h5")
model2 <- load_model_hdf5("best_models/my_model_cloudml_2020_05_18_145238086-009.h5")

model1 %>% evaluate_generator(generator = large_test, steps = large_test$n / large_test$batch_size)
model2 %>% evaluate_generator(generator = large_test, steps = large_test$n / large_test$batch_size)


# large_test$classes <- array(large_test$classes, dim = c(dim(large_test$classes), 1)) / 255
# 
# large_test$classes <- array_reshape(large_test$classes, c(1611,4))
# pred <- predict(model2, large_test$classes)
# large_test$classes
# generator_test$