library(imageRy)
library(terra)
library(viridis)

im.list() #mi dice le cose che ho in questa funzione -> tutti i file già scaricati

EN_01 = im.import("EN_01.png")
EN_01 = flip(EN_01)
plot(EN_01)




















































