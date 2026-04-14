# Script to import data from a computer or GitHub

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)

#i dati per ora le prendevamo da im.list() ora dobbiamo indicare a R la cartella che vogliamo utilizzare indicando il path con setwd()
setwd("C:\\Users\\User\\Desktop\\telerilevamento in R\\foto drone 2")
#windows users
list.files()
?rast()  #create a spatial raster
green = rast("DJI_20260409152942_0001_MS_G.TIF")
green = flip(green)
plot(green)

#mettiamo anche le altre bande
red = rast("DJI_20260409152942_0001_MS_R.TIF")
red = flip(red)
NIR = rast("DJI_20260409152942_0001_MS_nir.TIF")
NIR = flip(NIR)

#facciamo uno stack
stack = c(green,red,NIR)

#facciamo un'immagine in falsi colori -> codice del prof di coregistrattore per evitare di vedere lo sfasamento tra bande 
#usiamo plotRGB() che è una funzione del pacchetto "terra" 
#applico uno stretch="lin" che allunga con una relazione lineare tutti i valori per coprire tutti e 256 = 2^bit
plotRGB(stack, r=3, g=2, b=1, stretch="lin")   #il NIR è la 3° banda 
plotRGB(stack, r=3, g=2, b=1, stretch="hist")
#stretch = "hist" aumenta la discriminazione dei valori intermedi -> perde però i valori estremi (max e min) e quindi non converrebbe per la vegetazione






























































