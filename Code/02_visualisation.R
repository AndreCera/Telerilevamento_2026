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

#importo banda del blu b2

b2 = im.import("sentinel.dolomites.b2.tif")  #banda del blu
colorRampPalette(c("lightsalmon", "magenta", "mediumpurple1")(100)
plot(b2, col=cl)
plot(b2, col=mako(100))
plot(b2, col=inferno(100))
     
#par per multiframe
par(mfrow = c(1,2))

#riporto normale
par(mfrow = c(1,1))

# importing band 3 del verde
                 
b3 = im.import("sentinel.dolomites.b3.tif")  #banda del blu     

# importing band 4 del rosso
b4 = im.import("sentinel.dolomites.b4.tif")
                 
#importing band 8 - vicino infrarosso
b8 = im.import("sentinel.dolomites.b8.tif")   #NIR

                 
#esercizio fare 4 plot multiframe per ogni banda                 
                 
par(mfrow=c(2,2))
cl=colorRampPalette(c("lightblue","blue","darkblue"))(100)
plot(b2,col=cl)
cl=colorRampPalette(c("lightgreen","green","darkgreen"))(100)
plot(b3,col=cl)
cl=colorRampPalette(c("red","red2","red4"))(100)
plot(b4,col=cl)
cl=colorRampPalette(c("orange","magenta","red"))(100)
plot(b8,col=cl)         


#posso immaginare le bande come elementi di un vettore con la funzione stack
#stack   -> metto insieme tutte le bande in un oggetto
sentinel=c(b2,b3,b4,b8)
plot(sentinel)
plot(sentinel,col=inferno(100))
names(sentinel)
# [1] "sentinel.dolomites.b2" "sentinel.dolomites.b3" "sentinel.dolomites.b4" [4] "sentinel.dolomites.b8"       
# se voglio solo una banda
plot(sentinel$sentinel.dolomites.b8)
                 
library(devtools)
library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
install.packages("patchwork")
library(patchwork)
p1=im.ggplot(b8)
p2=im.ggplot(b4)
p1+p2
#multiframe
#1) par(mfrow=c(1,2))
#2) im.multiframe(1,2)
#3) 

#plotting RGB
                 
#sentinel=c(b2,b3,b4,b8)voglio plottare solo le bande del visibile
im.plotRGB(sentinel, r=3, g=2, b=1)    #l'occhio umano vedrebbe questo da quella quota
#falso colore
im.plotRGB(sentinel, r=4, g=3, b=2)  #con il rosso al NIR
im.plotRGB(sentdol, r=3, g=4, b=2)   #con il verde al NIR
                 
pairs(sentinel)		#correlation plot

plotRGB(sentinel,4,2,3,stretch="lin")   # mantiene lo schema iniziale (amplia il valore linearmente)
plotRGB(sentinel,4,2,3,stretch="hist")  #è solo un mezzo per aumentare il contrasto  (perché cambia il valore)
                 

                 






