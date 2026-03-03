# R code for visualizing satellite data

# install.packages("viridis")
# install.packages("devtools")
library(devtools)
# install_github("ducciorocchini/imageRy")

library(terra)
library(imageRy)
library(viridis)

im.list()
# Sentinel bands:
# https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/bands/

b2 = im.import("sentinel.dolomites.b2.tif")








