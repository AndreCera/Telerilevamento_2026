# Questo sarà il titolo del mio rpogetto di esame
l'area di studio ...
## Pacchetti utilizzati
per questo esame ho usato i pacchetti...
``` r
library(terra) # pacchetto per
```
## Importazione dei dati 
i dati sono stati scaricati da Earth observary https://science.nasa.gov/earth/earth-observatory/image-of-the-day/
oppure posso scrivere così: [earth observatory](https://science.nasa.gov/earth/earth-observatory/image-of-the-day/)

Il codice utilizzato è il seguente 
prima di tutto selezioniamo al working directory
``` r
setwd("C:\\Users\\User\\Desktop\\telerilevamento in R")

getwd()

list.files()
```
Per importare i dati è stata usata la funzione `rast()` del pacchetto `terra`: 
```r
richat = rast( "richatstructure_oli_20260306.jpg")

richat = flip(richat)

plot(richat)
```
<img width="480" height="480" alt="figura3" src="https://github.com/user-attachments/assets/e863e91e-4511-42f8-81fc-0080edcee568" />


## Analisi esplorativa 
Prima di tutto plottaggio delle singole bande 
```r
im.multiframe(2,1)
plot(richat[[1]])
plot(richat[[2]])
```
<img width="480" height="480" alt="figura3" src="https://github.com/user-attachments/assets/2bf9a84f-b3d0-4ae3-9897-d574c96a4213" />

## Prove con chatgpt

```r
val1 <- values(richat[[1]])
val2 <- values(richat[[2]])
val3 <- values(richat[[3]])

hist(val1, main="Istogramma Banda 1", col="lightblue")
hist(val2, main="Istogramma Banda 2", col="lightgreen")
hist(val3, main="Istogramma Banda 3", col="red")
```

<img width="480" height="480" alt="fingura4" src="https://github.com/user-attachments/assets/fd947813-0fad-4b00-863d-d3216e9ea8da" />




