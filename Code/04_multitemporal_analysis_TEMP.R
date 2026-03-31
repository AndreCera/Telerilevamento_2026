library(imageRy)
library(terra)
library(viridis)
library(ggplot2)
library(ggridges)

im.list() #mi dice le cose che ho in questa funzione -> tutti i file già scaricati

EN_01 = im.import("EN_01.png")    #concentrazione di N nella troposfera del 2001
EN_01 = flip(EN_01)
plot(EN_01)

EN_13 = im.import("EN_13.png")  ##concentrazione di N nella troposfera del 2001
EN_13 = flip(EN_13)
plot(EN_13)
im.multiframe(1,2)

ENdif = EN_01[[1]] - EN_13[[1]]   #
plot(ENdif)
plot(ENdif, col=inferno(100))

# Greenland ice melt
gr00 = im.import("greenland.2000.tif")
gr05 = im.import("greenland.2005.tif")
gr10 = im.import("greenland.2010.tif")
gr15= im.import("greenland.2015.tif")
greenland = c(gr00, gr05, gr10, gr15)

im.multiframe(1,2)
plot(gr00)
plot(gr15)

grdif = gr[[4]] - gr[[1]] # 2015 - 2000
plot(grdif)
# All the yellow parts are those in which there is a higher value in 2015

im.multiframe(1,2)
plot(gr[[1]],col=plasma(100))
plot(gr[[4]],col=plasma(100))

grdif = gr[[4]] - gr[[1]] # 2015 - 2000
plot(grdif)

im.plotRGB(gr,r=1,2,4)

#lezione del 31/03
im.list()
#caricare tutti i file con quella parte di nome in comune 
ndvi = im.import("Sentinel2_NDVI") 
plot(ndvi, col=plasma(100))
hist(ndvi)
#i ridge line plots ottengo per ogni mappa come varia una zona in un periodo
library(ggridges)
im.ridgeline(ndvi, scale=2, palette=viridis) #lui mi dà un solo plot -> lo sovrascrive ogni volta
names(ndvi) = c("02_feb", "05_may", "08_aug", "11_nov")
im.ridgeline(ndvi, scale=1, palette=viridis)

pairs(ndvi) #corr plot
ndvi
plot(ndvi[[1]],ndvi[[2]])
# y = x
# y = a + bx
# y = 0 + 1x = x
# a = 0
# b = 1
#aggiungiamo una linea rosssa bisettrice 1°- 3° quadrante
abline(0, 1, col="red")
# non è la bisettrice 1°- 3° quadrante perché devo ettare i limiti del grafico
plot(ndvi[[1]],ndvi[[2]], xlim=c(-0.3,0.9), ylim=c(-0.3,0.9))
abline(0, 1, col="red")



























