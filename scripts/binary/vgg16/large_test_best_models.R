library(keras)
library(cloudml)
library(tfruns)
library(kerasR)
library(caret)

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

large_test$batch_size <- large_test$n 
large_test$shuffle <- FALSE


#-----------------------------------------------------#
#Evaluate model2

model1 <- load_model_hdf5("best_models/vgg16_binary/best_vgg16_binary.h5")
model2 <- load_model_hdf5("best_models/vgg16_binary/best_second_vgg16_binary.h5")
model1 %>% evaluate_generator(generator = large_test,steps = large_test$n / large_test$batch_size)
model2 %>% evaluate_generator(generator = large_test,steps = large_test$n / large_test$batch_size)

# predicted <- model2 %>% predict_generator(generator = large_test, steps = large_test$n)
# predicted_tr <- (apply(predicted, MARGIN = 1, which.max) - 1) %>% as.factor()
# observed <- large_test$classes %>% as.factor()
# caret::confusionMatrix(predicted_tr, observed)
