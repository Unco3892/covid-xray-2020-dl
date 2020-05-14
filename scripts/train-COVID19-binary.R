library(keras)
library(cloudml)
library(tfruns)

# Define the hyperparameter for tuning
# ------------------------------------
FLAGS <- flags(
  flag_numeric("lr", 0.0001)
)


# Define the generator
# ------------------------------------
generator <- image_data_generator(rescale = 1 / 255, validation_split = 0.2)


# Import images
# ------------------------------------
train <- flow_images_from_directory(
  directory = gs_data_dir_local(
    "gs://deep-learning-274116/natural-images/train"
  ),
  target_size = c(100, 100),
  generator = generator,
  batch_size = 8,
  subset = "training"
)

valid <- flow_images_from_directory(
  directory = gs_data_dir_local(
    "gs://deep-learning-274116/natural-images/train"
  ),
  target_size = c(100, 100),
  generator = generator,
  batch_size = 8,
  subset = "validation"
)

#-----------------------------------------------------#
#LeNet5 model architecture

model <- keras_model_sequential() %>%
  layer_conv_2d(filters = 6, kernel_size = c(5, 5),
                strides = 1, padding = "same", # Note that we have used padding although it was not requested in the exercise but it was mentioned in the slides so it has been implemented.
                activation = "relu",
                input_shape = c(100, 100, 3)) %>% 
  layer_average_pooling_2d(pool_size = c(2, 2), strides = 2) %>% 
  layer_conv_2d(filters = 16, kernel_size = c(5, 5),
                strides = 1, activation = "relu") %>% 
  layer_average_pooling_2d(pool_size = c(2, 2), strides = 2) %>% 
  layer_conv_2d(filters = 120, kernel_size = c(5, 5),
                strides = 1, activation = "relu") %>% 
  layer_flatten() %>%
  layer_dense(units = 84, activation = "relu") %>% 
  layer_dense(units = 8, activation = "softmax")

# Compile with the flags
model %>% compile(
  loss = "categorical_crossentropy",
  optimizer = optimizer_rmsprop(FLAGS$lr),
  metric = "accuracy"
)    

# fit with the flags
model %>% fit_generator(
  generator = train, 
  steps_per_epoch = train$n / train$batch_size,
  epochs = 100,
  validation_data = valid,
  validation_steps = valid$n / valid$batch_size,
  callbacks = callback_early_stopping(patience = 5,
                                      restore_best_weights = TRUE)
)    