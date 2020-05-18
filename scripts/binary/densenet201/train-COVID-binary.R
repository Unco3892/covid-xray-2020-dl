library(keras)
library(cloudml)
library(tfruns)

# Define the hyperparameter for tuning
# ------------------------------------
FLAGS <- flags(
  flag_numeric("units1", 100),
  flag_numeric("units2", 100),
  flag_numeric("lr", 0.0001), 
  flag_numeric("dropoutrate", 0.2), 
  flag_numeric("reg", 0.001),
  flag_string("optimizer", "optimizer_rmsprop"), 
  flag_string("activation", "relu")
)

# All the hyperparameters have to go the yml file that will be sent to the cloud:
# - 100 from unit2
# - "adamax" from optimizer
# - "selu" activ

# Define the generator
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
  directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  #directory = here::here("data/final_data/binary/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "training"
)

valid <- flow_images_from_directory(
  directory = gs_data_dir_local("gs://covid-pw2/final_data/binary/train"),
  #directory = here::here("data/final_data/binary/train"),
  target_size = c(224, 224),
  generator = generator,
  batch_size = 16,
  subset = "validation"
)

#-----------------------------------------------------#
#VGG-16 model architecture

conv_base <- keras::application_densenet201(
  include_top = FALSE,
  weights = "imagenet",
  input_shape = c(224, 224, 3)
)

freeze_weights(conv_base)

model <- keras_model_sequential() %>%
  conv_base %>%
  layer_flatten() %>%
  layer_dense(units = FLAGS$units1, activation = FLAGS$activation, kernel_regularizer = regularizer_l1(FLAGS$reg)) %>%
  layer_dense(units = FLAGS$units2, activation = FLAGS$activation) %>%
  layer_dropout(rate = FLAGS$dropoutrate) %>%
  layer_dense(units = 2, activation = "softmax")

model %>% compile(
  optimizer = match.fun(FLAGS$optimizer)(lr = FLAGS$lr),
  loss = loss_categorical_crossentropy, #loss_categorical_crossentropy
  metric = metric_categorical_accuracy # metric_categorical_accuracy
)

model %>% fit_generator(
  generator = train,
  steps_per_epoch = train$n / train$batch_size,
  epochs = 30,
  callbacks = callback_early_stopping(patience = 7,
                                      restore_best_weights = TRUE),
  validation_data = valid,
  validation_steps = valid$n / valid$batch_size
)