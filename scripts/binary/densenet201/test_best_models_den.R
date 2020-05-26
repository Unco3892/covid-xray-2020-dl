library(keras)
library(cloudml)
library(tfruns)
library(here)

visu
# ------------------------------------
generator <-
  image_data_generator(
    rescale = 1 / 255,
    validation_split = 0.2,
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

test <- flow_images_from_directory(
  #directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/test"),
  directory = here::here("data/final_data/binary/test"),
  target_size = c(224, 224),
  generator = generator_test,
  batch_size = 16, 
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
#VGG-16 model architecture

conv_base <- keras::application_vgg16(
  include_top = FALSE,
  weights = "imagenet",
  input_shape = c(224, 224, 3)
)

freeze_weights(conv_base)




#-----------------------------------------------------#
  #Model 1 architecture my_model_cloudml_2020_05_18_145238086-054
  

model1 <- keras_model_sequential() %>%
  conv_base %>%
  layer_flatten() %>%
  layer_dense(units = 100, activation = "relu", kernel_regularizer = regularizer_l1(0.00)) %>%
  layer_dense(units = 100, activation = "relu") %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 2, activation = "softmax")

model1 %>% compile(
  optimizer = optimizer_adamax(lr = 0.001),
  #loss = loss_categorical_crossentropy, 
  loss = "categorical_crossentropy", #loss_categorical_crossentropy
  metric = metric_categorical_accuracy # metric_categorical_accuracy
)

model1 %>% fit_generator(
  generator = train,
  steps_per_epoch = train$n / train$batch_size,
  epochs = 30,
  callbacks = callback_early_stopping(patience = 7,
                                      restore_best_weights = TRUE),
  validation_data = valid,
  validation_steps = valid$n / valid$batch_size
)

model1 %>% 
  save_model_hdf5(here::here("best_models/densenet201_binary/best_densenet201_binary050.h5"))

#-----------------------------------------------------#
#Evaluate model1
model1 <- load_model_hdf5(here::here("best_models/densenet201_binary/best_densenet201_binary050.h5"))
model1 %>% evaluate_generator(generator = large_test, steps = large_test$n / large_test$batch_size)











