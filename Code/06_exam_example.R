library(terra)
setwd("C:\\Users\\User\\Desktop\\telerilevamento in R")
getwd()
list.files()
richat = rast( "richatstructure_oli_20260306.jpg")

png("figura3.png")
plot(richat)
richat = flip(richat)
plot(richat)

#salvo il plot nella cartella
png("figura3.png")
plot(richat)
dev.off()

png("figura3.png")
im.multiframe(2,1)
plot(richat[[1]])
plot(richat[[2]])
dev.off()  

#posso farmi aiutare da chatgpt
png("fingura4.png")
im.multiframe(2,2)
val1 <- values(richat[[1]])
val2 <- values(richat[[2]])
val3 <- values(richat[[3]])

hist(val1, main="Istogramma Banda 1", col="lightblue")
hist(val2, main="Istogramma Banda 2", col="lightgreen")
hist(val3, main="Istogramma Banda 3", col="red")
dev.off()























