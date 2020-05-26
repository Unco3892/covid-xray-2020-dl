library(keras)
library(cloudml)
library(tfruns)
library(here)


# Visualizing the images
# We take on COVID+ and one COVID- and the same for multiclass classification
# Class activation map
# We will use gradcam from here and here
# https://jjallaire.github.io/deep-learning-with-r-notebooks/notebooks/5.4-visualizing-what-convnets-learn.nb.html
# https://arxiv.org/abs/1610.02391


# Load the mc model (or bianry)
vgg16_mc <- load_model_hdf5(here::here("best_models/vgg16_mc/best_vgg16_mc.h5"))
vgg16_binary <- load_model_hdf5(here::here("best_models/vgg16_binary/best_second_vgg16_binary.h5"))


# An example of an image from the COVID+ 
img_path <- here::here("data/final_data/binary/test/COVID+/paving.jpg")
img <- image_load(img_path, target_size = c(224, 224)) %>% 
  # Array of shape (224, 224, 3)
  image_to_array() %>% 
  # Adds a dimension to transform the array into a batch of size (1, 224, 224, 3)
  array_reshape(dim = c(1, 224, 224, 3)) %>% 
  # Preprocesses the batch (this does channel-wise color normalization)
  imagenet_preprocess_input()

preds <- vgg16_mc %>% predict(img)

imagenet_decode_predictions(preds, top = 1)

which.max(preds[1,])




# This is the "african elephant" entry in the prediction vector
african_elephant_output <- model$output[, 387]
# The is the output feature map of the `block5_conv3` layer,
# the last convolutional layer in VGG16
last_conv_layer <- model %>% get_layer("block5_conv3")
# This is the gradient of the "african elephant" class with regard to
# the output feature map of `block5_conv3`
grads <- k_gradients(african_elephant_output, last_conv_layer$output)[[1]]
# This is a vector of shape (512,), where each entry
# is the mean intensity of the gradient over a specific feature map channel
pooled_grads <- k_mean(grads, axis = c(1, 2, 3))
# This function allows us to access the values of the quantities we just defined:
# `pooled_grads` and the output feature map of `block5_conv3`,
# given a sample image
iterate <- k_function(list(model$input),
                      list(pooled_grads, last_conv_layer$output[1,,,])) 
# These are the values of these two quantities, as arrays,
# given our sample image of two elephants
c(pooled_grads_value, conv_layer_output_value) %<-% iterate(list(img))
# We multiply each channel in the feature map array
# by "how important this channel is" with regard to the elephant class
for (i in 1:512) {
  conv_layer_output_value[,,i] <- 
    conv_layer_output_value[,,i] * pooled_grads_value[[i]] 
}
# The channel-wise mean of the resulting feature map
# is our heatmap of class activation
heatmap <- apply(conv_layer_output_value, c(1,2), mean)


