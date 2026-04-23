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

#sfruttiamo la classificazion eper fare una pmappa di confronto di uso del suolo del matogrosso
im.list() 
im.multiframe(2,1)
m1992 = im.import("matogrosso_l5_1992219_lrg.jpg")
m2006 = im.import("matogrosso_ast_2006209_lrg.jpg")

m1992_class = im.classify(m1992, seed=42, num_clusters = 2)
m2006_class = im.classify(m2006, seed=42, num_clusters = 2
# Assign labels -> diciamo cosa è cosa 
levels(m1992_class) <- data.frame(
  value = c(1, 2),
  label = c("forest", "human")
)
levels(m2006_class) <- data.frame(
  value = c(2, 1),
  label = c("forest", "human")
)
setwd("C:\\Users\\User\\Desktop\\telerilevamento in R")

#calculating frequencies 
f1992 = freq(m1992_class)
f2006 = freq(m2006_class)    # risultato in pixel
#voglio il risultato in frequenza relativa
                          
f1992$count                          
f2006$count

fperc_1992 = f1992$count/ncell(m1992_class)*100
fperc_2006 = f2006$count/ncell(m2006_class)*100
# fperc_1992
# 83.08683 16.91317
# fperc_2006
# 54.69439 45.30561


                    
#Table
tabout <- data.frame(class = c("Forest","Human"), perc1992 = c(83, 17), perc2006 = (45,55))

# Using the ggplot2 package for the final graph
p1 <- ggplot(tabout, aes(x=class, y=perc1992, color=class)) + #per la struttura
      geom_bar(stat="identity", fill="white") + #per dire che voglio un barrplot/istogramma e la colorazione interna 
      ylim(c(0,100)) + #limits
      theme(legend.position="none")       #non avere la legenda    
               
p2 <- ggplot(tabout, aes(x=class, y=perc2006, color=class)) + #per la struttura
      geom_bar(stat="identity", fill="white")+ #per dire che voglio un barrplot/istogramma e la colorazione interna          
      ylim(c(0,100)) + #limits
      theme(legend.position="none") 
                     
p1 + p2   #funzione del pacchetto patchwork per aggiungere e fondere 2 grafici

													

                          













