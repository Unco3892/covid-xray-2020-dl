library(keras)
library(cloudml)
library(tfruns)


# ------------------------------------
generator <-
  image_data_generator(
    rescale = 1 / 255,
    validation_split = 0.5,
    zoom_range = 0.2
  )

# Import images
# ------------------------------------
train <- flow_images_from_directory(
  #directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  directory = here::here("data/final_data/binary/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "training"
)

valid <- flow_images_from_directory(
  #directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  directory = here::here("data/final_data/binary/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "validation"
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
#Model 1 architecture cloudml_2020_05_18_145238086-112


model1 <- keras_model_sequential() %>%
  conv_base %>%
  layer_flatten() %>%
  layer_dense(units = 200, activation = "selu", kernel_regularizer = regularizer_l1(0.001)) %>%
  layer_dense(units = 100, activation = "selu") %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 2, activation = "softmax")

model1 %>% compile(
  optimizer = optimizer_rmsprop(lr = 0.0001),
  loss = loss_categorical_crossentropy, #loss_categorical_crossentropy
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
save_model_hdf5(here::here("best_models/my_model_cloudml_2020_05_18_145238086-112.h5"))


#-----------------------------------------------------#
#Model 2 architecture my_model_cloudml_2020_05_18_145238086-009


model2 <- keras_model_sequential() %>%
  conv_base %>%
  layer_flatten() %>%
  layer_dense(units = 100, activation = "relu", kernel_regularizer = regularizer_l1(0.0)) %>%
  layer_dense(units = 50, activation = "relu") %>%
  layer_dropout(rate = 0) %>%
  layer_dense(units = 2, activation = "softmax")

model2 %>% compile(
  optimizer = optimizer_rmsprop(lr = 0.0001),
  loss = loss_categorical_crossentropy, #loss_categorical_crossentropy
  metric = metric_categorical_accuracy # metric_categorical_accuracy
)

model2 %>% fit_generator(
  generator = train,
  steps_per_epoch = train$n / train$batch_size,
  epochs = 30,
  callbacks = callback_early_stopping(patience = 7,
                                      restore_best_weights = TRUE),
  validation_data = valid,
  validation_steps = valid$n / valid$batch_size
)

model2 %>% 
save_model_hdf5(here::here("best_models/my_model_cloudml_2020_05_18_145238086-009.h5")


