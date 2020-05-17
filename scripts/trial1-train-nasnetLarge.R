library(keras)
library(cloudml)

# Define the generator
# ------------------------------------
generator <-
  image_data_generator(
    rescale = 1 / 255,
    validation_split = 0.2,
    zoom_range = 0.2
  )

# Import images
# ------------------------------------
train <- flow_images_from_directory(
  directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  # directory = here::here("data/final_data/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "training"
)

valid <- flow_images_from_directory(
  directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  # directory = here::here("data/final_data/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "validation"
)

#-----------------------------------------------------#
# DenseNet201 model architecture
# conv_base <- application_densenet201(
#   include_top = FALSE,
#   weights = "imagenet",
#   input_shape = c(224, 224, 3)
# )

conv_base <- application_nasnetlarge(
  include_top = FALSE,
  weights = "imagenet",
  input_shape = c(224, 224, 3)
)
freeze_weights(conv_base)

model <- keras_model_sequential() %>%
  conv_base %>%
  layer_flatten() %>%
  layer_dense(units = 100, activation = "relu") %>%
  layer_dense(units = 100, activation = "relu") %>%
  layer_dense(units = 2, activation = "sigmoid")


model %>% compile(optimizer = optimizer_rmsprop(lr = 0.0001),
                  loss = loss_binary_crossentropy,
                  metric = "accuracy")

model %>% fit_generator(
  generator = train,
  steps_per_epoch = train$n / train$batch_size,
  epochs = 30,
  callbacks = callback_early_stopping(patience = 7,
                                      restore_best_weights = TRUE),
  validation_data = valid,
  validation_steps = valid$n / valid$batch_size
)