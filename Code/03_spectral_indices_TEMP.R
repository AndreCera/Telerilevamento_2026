library(imageRy) # beloved package developed at unibo
library(terra)
library(viridis)

#importiamo l'imamgine della foresta amazzonica del 1992
mato1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992 = flip(mato1992)           #orienta secondo il nord

im.plotRGB(mato1992, r=1, g=2, b=3) #NIR al posto del rosso
im.plotRGB(mato1992, r=2, g=1, b=3) #NIR al posto del verde
im.plotRGB(mato1992, r=2, g=3, b=1) #NIR al posto del blu

#importiamo anche l'immagine del 2006
mato2006 = im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 = flip(mato2006)

im.plotRGB(mato2006, r=1, g=2, b=3) #NIR al posto del rosso
im.plotRGB(mato2006, r=2, g=1, b=3) #NIR al posto del verde
im.plotRGB(mato2006, r=2, g=3, b=1) #NIR al posto del blu

#plot multiframe
im.multiframe(1,2)
im.plotRGB(mato1992, r=1, g=2, b=3)
im.plotRGB(mato2006, r=1, g=2, b=3)   #si vedono chiaramente gli effetti del disboscamento 

#funzione terra plotRGB()
plotRGB(mato1992, r=1, g=2, b=3, stretch="hist")
plotRGB(mato2006, r=1, g=2, b=3, stretch="hist")

#NIR sul verde
plotRGB(mato1992, r=2, g=1, b=3, stretch="hist")
plotRGB(mato2006, r=2, g=1, b=3, stretch="hist")

#NIR sul blu
plotRGB(mato1992, r=2, g=2, b=1, stretch="hist")
plotRGB(mato2006, r=2, g=2, b=1, stretch="hist")

#andiamo a calcolare l'DVI (non ancora normalizzato)
DVI1992= mato1992[[1]]-mato1992[[2]]
DVI2006= mato2006[[1]]-mato2006[[2]]
plot(DVI1992)

#consideriamo una risoluzione radiometrica con 8 bit
#NIR - red = 255 - 0 = 255 max DVI
#NIR - red = 0 - 255 = -255 max DVI

#consideriamo una risoluzione radiometrica con 4 bit
#NIR - red = 15 - 0 = 15 max DVI
#NIR - red = 0 - 15 = -15 min DVI

# NDVI -> è una standardizzazione -> (NIR – red) / (NIR + red)
#ES 8 bit e 4 bit -> non cambia
# NDVI max e MIN sono sempre 

NDVI1992 = (mato1992[[1]] - mato1992[[2]]) / (mato1992[[1]] + mato1992[[2]])
NDVI2006 = (mato2006[[1]] - mato2006[[2]]) / (mato2006[[1]] + mato2006[[2]])

plot(NDVI1992, col=inferno(100))
plot(NDVI2006, col=inferno(100))

#esistono funzioni di imageRy per DVI (solo se si ha la stessa risoluzione radiometrica) e NDVI
im.dvi(mato1992,1,2)
im.dvi(mato2006,1,2)

ndvi1992 = im.ndvi(mato1992,1,2)
ndvi2006 = im.ndvi(mato2006,1,2)
plot(ndvi1992,col=rocket(100))
plot(ndvi2006,col=rocket(100))











