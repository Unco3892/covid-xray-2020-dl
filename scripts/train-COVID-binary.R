library(keras)
library(cloudml)
library(tfruns)

# Define the hyperparameter for tuning
# ------------------------------------
FLAGS <- flags(
  flag_numeric("units1", 200),
  flag_numeric("units2", 100, 200),
  flag_numeric("lr", 0.0001), 
  flag_string("optimizer", "rmsprop", "adamax"),
  flag_string("activ", "relu", "selu")
)


# Define the generator
# ------------------------------------
generator <- image_data_generator(rescale = 1 / 255, validation_split = 0.2, zoom_range = 0.2)


# Import images
# ------------------------------------
train <- flow_images_from_directory(
  directory = gs_data_dir_local(
    "gs://covid-pw2/data/final_data/train"
  ),
  target_size = c(100, 100),
  generator = generator,
  batch_size = 16,
  subset = "training"
)

valid <- flow_images_from_directory(
  directory = gs_data_dir_local(
    "gs://covid-pw2/data/final_data/train"
  ),
  target_size = c(100, 100),
  generator = generator,
  batch_size = 16,
  subset = "validation"
)

# Define the generator
# ------------------------------------
generator <- image_data_generator(rescale = 1 / 255, validation_split = 0.2)


# WHY TWICE?
# Import images
# ------------------------------------
train <- flow_images_from_directory(
  directory = gs_data_dir_local(
    "gs://covid-pw2/data/final_data/train"
  ),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 8,
  subset = "training"
)

valid <- flow_images_from_directory(
  directory = gs_data_dir_local(
    "gs://deep-learning-274116/natural-images/train"
  ),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 8,
  subset = "validation"
)


#-----------------------------------------------------#
#DenseNet201 model architecture


conv_base <- application_densenet201(include_top = FALSE, 
                                     weights = "imagenet", 
                                     input_shape = c(224, 224, 3))

freeze_weights(conv_base)

model <- keras_model_sequential() %>%
  conv_base %>%
  layer_flatten() %>%
  layer_dense(units = FLAGS$units1, activation = FLAGS$activ) %>%
  layer_dense(units = FLAGS$units2, activation = FLAGS$activ) %>%
  layer_dense(units = 2, activation = "softmax")


model %>% compile(
  optimizer = match.fun(FLAGS$optimizer)(lr = FLAGS$lr),
  loss = loss_categorical_crossentropy,
  metric = "accuracy"
)

model %>% fit_generator(
  generator = train,
  steps_per_epoch = train$n / train$batch_size,
  epochs = 100,
  callbacks = callback_early_stopping(patience = 7,
                                      restore_best_weights = TRUE),
  validation_data = valid,
  validation_steps = valid$n / valid$batch_size
)