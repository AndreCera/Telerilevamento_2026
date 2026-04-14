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

# NDVI
ndvi = im.ndvi(stack,3,2)

plot(ndvi, col=magma(100))
plot(ndvi, col=plasma(20))

# esportare i dati in tiff
writeRaster(ndvi, "ndvi.tif") #funzione sensibile alle maiuscole
#ora appare nella mia cartella che ho settato all'inizio
list.files()
ndvi2=rast( "ndvi.tif"  )  #proviamo a ricaricarla
im.multiframe(1,2)
plot(ndvi)
plot(ndvi2) #sono uguali

#exporting a figure (no data)!
png("figura1.png")   #file immagine con risoluzione prestabilita bassa
im.multiframe(2,2)
plot(green)
plot(red)
plot(NIR)
plot(ndvi)
dev.off()

#oppure PDF -> file vettoriale con risoluzione non predefinita e scritte perfette 
pdf("figura1.pdf")   
im.multiframe(2,2)
plot(green)
plot(red)
plot(NIR)
plot(ndvi)
dev.off()

#utilizzo il pacchetto "patchwork"
p1 = im.ggplot(ndvi)
p2= im.ridgeline(ndvi, scale = 1)
p1 + p2

png("figura2.png") 
p1 + p2
dev.off()   #non funziona perché bisogna mettersi lì a lavorare con le altezze (vedi pacchetto)

#importare dati direttamente da GitHub su R
#copio il link
# https://github.com/ducciorocchini/Telerilevamento_2026/tree/main/Drone2
# edito "github" in "raw.githubusercontent" ed elimino "tree"
# https://raw.githubusercontent.com/ducciorocchini/Telerilevamento_2026/main/Drone2
green_github = rast("https://raw.githubusercontent.com/ducciorocchini/Telerilevamento_2026/main/Drone2/DJI_20260409152942_0001_MS_G.TIF")
green_github = flip(green_github)
plot(green_github)






































