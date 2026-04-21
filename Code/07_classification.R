library(terra)
library(imageRy)
library(ggplot2)
# install.packages("patchwork")
library(patchwork)

im.list()

sun = im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
#facciamo una classificazione non supervisionata
?im.classify() 
sun_class = im.classify(sun, num_clusters = 3)  # mi fa 3 classi con 3 colori casuali -> devo specificare il seed
sun_class = im.classify(sun, num_clusters = 12, seed = 3)   #posso anche overclassificare poi accorpo con dei subset
GC = im.import("dolansprings_oli_2013088_canyon_lrg.jpg" )
GC_class = im.classify(GC, num_clusters = 4, seed = 42)

# funzione im.fazy() -> si basa sulle distanza dei centri dei pixel
ncell(sun)    #2221440
ncell(GC)     #58076148 un ordine di grandezza in più

#facciamolo su un'immagine a piacere 
setwd("C:\\Users\\User\\Downloads")
chess = rast("IMG-20190803-WA0000.jpg")
plot(chess)
chess = flip(chess)
plot(chess)
chess_class = im.classify(chess, num_clusters = 7, seed = 42)
png("chess_class.png")
plot(chess_class)
dev.off()

png("kayak.png")





























