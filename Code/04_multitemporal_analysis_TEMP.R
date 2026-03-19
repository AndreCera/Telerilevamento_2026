library(imageRy)
library(terra)
library(viridis)

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

dif = 

im.plotRGB(gr,r=1,2,4)







































