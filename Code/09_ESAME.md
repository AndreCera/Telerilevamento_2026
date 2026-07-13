
# Monitoraggio Multitemporale e Analisi Spaziale degli Effetti del Parossismo del 2019 all'Isola di Stromboli tramite Dati Sentinel-2

## Introduzione e Obiettivi del Progetto
Questo progetto nasce con l'obiettivo di analizzare qualitativamente e quantitativamente gli effetti sul paesaggio costiero e vegetale prodotti dal parossismo vulcanico avvenuto sull'isola di Stromboli il 3 luglio 2019. L'esplosione ha innescato una serie di incendi secondari causati dalla ricaduta di clasti balistici incandescente (scorie) che ha colpito duramente i fianchi dell'edificio vulcanico, distruggendo ampie porzioni di macchia mediterranea[cite: 1].

Prendendo come punto di partenza metodologico il recente lavoro scientifico di Iacono et al. (2025), il quale si focalizza sulla perimetrazione del danno immediato nel periodo estivo del 2019 tramite il confronto di dati multispettrali e rilievi da drone, questo studio si propone di ampliare l'orizzonte dell'indagine secondo tre direttrici principali[cite: 1]:
1. **Estensione della finestra temporale (Analisi del Recupero):** A differenza della letteratura esistente che si ferma alla quantificazione del danno cumulativo a settembre 2019, questo report spinge l'analisi fino a giugno 2020 per verificare a un anno di distanza il tasso reale di recupero e la capacità di resilienza pioniera della vegetazione[cite: 1].
2. **Integrazione del contesto petrografico e geologico:** Accanto agli indici forestali standard (NDVI, NBR), viene testato il *Ferrous Iron Index* per mappare l'impronta spettrale delle ceneri e dei basalti freschi depositati sul vulcano[cite: 1].
3. **Ottimizzazione delle tecniche di mascheramento:** Viene sviluppato un workflow basato sull'indice normalizzato NDWI per risolvere il problema del fallimento dello spettro continuo sui suoli vulcanici neri (Sciara del Fuoco), separando chirurgicamente la terraferma dallo sfondo marino.

Tutti i dati grezzi sono stati scaricati direttamente dal browser open source dell'ESA Copernicus. Questa scelta è stata preferita rispetto all'uso di Google Earth Engine (GEE) per mantenere un controllo radiometrico e visivo assoluto sulle singole scene: trattandosi di un vulcano attivo, le emissioni di gas e le frequenti coperture nuvolose locali rendono molte scene inadatte, richiedendo una selezione manuale rigorosa della linea temporale.

---

## Area di Studio
"Stromboli volcano represents the uppermost portion of a larger edifice extending to a depth of 1500–2600 m below sea level[cite: 1]. The Vancori is the highest part of the volcano edifice (924 m a.s.l.) while the volcanic activity takes place in the crater terrace, a flattened area located in the upper part of the deserted Sciara del Fuoco, where several active vents are always present" (Iacono et al., 2025)[cite: 1]. L'isola è caratterizzata da una copertura vegetale dominata da arbusti della macchia mediterranea (*Genista tyrrhena*, *Spartium junceum*) e associazioni erbacee, fortemente esposte al rischio di incendi secondari in caso di attività esplosive parossistiche[cite: 1].

---

## Pre-elaborazione Dati, Allineamento e Visualizzazione RGB

In questa prima fase carichiamo i pacchetti necessari, impostiamo la cartella di lavoro sul PC e importiamo le bande a 10 metri (e la banda 12 a 20 metri per lo SWIR) per le tre date selezionate: Giugno 2019 (Pre-evento), Agosto 2019 (Post-evento) e Giugno 2020 (Recupero).

```r
library(terra)      # Per lavorare con raster e immagini satellitari
library(imageRy)    # Funzioni di visualizzazione rapide
library(viridis)    # Palette di colori
library(ggplot2)    # Pacchetto per la creazione di grafici
library(reshape2)   # Riorganizzazioni dei dati tabellari

# Configurazione della cartella principale di lavoro (Working Directory)
setwd("C:/Users/User/Desktop/telerilevamento in R/progetto esame Stromboli")

# GIUGNO - PRE
b2_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B02_10m.jp2")
b3_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B03_10m.jp2")
b4_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B04_10m.jp2")
b8_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B08_10m.jp2")
b12_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R20m/T33SWC_20190607T095031_B12_20m.jp2")

# AGOSTO - POST
b2_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B02_10m.jp2")
b3_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B03_10m.jp2")
b4_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B04_10m.jp2")
b8_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B08_10m.jp2")
b12_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R20m/T33SWC_20190811T095039_B12_20m.jp2")

# GIUGNO 2020 - RECUPERO (?)
b2_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B02_10m.jp2")
b3_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B03_10m.jp2")
b4_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B04_10m.jp2")
b8_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B08_10m.jp2")
b12_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R20m/T33SWD_20200626T095029_B12_20m.jp2")
```

Per ritagliare l'area dell'isola in modo millimetrico, impostiamo i confini geografici cartesiani e usiamo la funzione `crop()`. La banda 12 (SWIR), nata originariamente a 20 metri di risoluzione geometrica[cite: 1], viene forzata tramite un ricampionamento bilineare (`resample()`) sulla griglia spaziale a 10 metri delle altre bande per poter creare gli stack.

```r
# Definizione dell estensione cartesiana dell isola (xmin, xmax, ymin, ymax)
estensione_stromboli <- ext(515715, 521500, 4291265, 4296385)

# Ritaglio e allineamento geometrico di tutte le bande per le tre date
b2_giu19_crop <- crop(b2_giu19, estensione_stromboli)
b3_giu19_crop <- crop(b3_giu19, estensione_stromboli)
b4_giu19_crop <- crop(b4_giu19, estensione_stromboli)
b8_giu19_crop <- crop(b8_giu19, estensione_stromboli)
b12_giu19_crop <- resample(crop(b12_giu19, estensione_stromboli), b2_giu19_crop, method="bilinear")

b2_ago19_crop <- crop(b2_ago19, estensione_stromboli)
b3_ago19_crop <- crop(b3_ago19, estensione_stromboli)
b4_ago19_crop <- crop(b4_ago19, estensione_stromboli)
b8_ago19_crop <- crop(b8_ago19, estensione_stromboli)
b12_ago19_crop <- resample(crop(b12_ago19, estensione_stromboli), b2_ago19_crop, method="bilinear")

b2_giu20_crop <- crop(b2_giu20, estensione_stromboli)
b3_giu20_crop <- crop(b3_giu20, estensione_stromboli)
b4_giu20_crop <- crop(b4_giu20, estensione_stromboli)
b8_giu20_crop <- crop(b8_giu20, estensione_stromboli)
b12_giu20_crop <- resample(crop(b12_giu20, estensione_stromboli), b2_giu20_crop, method="bilinear")

# Costruzione degli stack multispettoriali definitivi
str_giu_19 <- c(b2_giu19_crop, b3_giu19_crop, b4_giu19_crop, b8_giu19_crop, b12_giu19_crop)
str_ago_19 <- c(b2_ago19_crop, b3_ago19_crop, b4_ago19_crop, b8_ago19_crop, b12_ago19_crop)
str_giu_20 <- c(b2_giu20_crop, b3_giu20_crop, b4_giu20_crop, b8_giu20_crop, b12_giu20_crop)

# Ridenominazione stringente dei layer per mantenere il codice pulito
names(str_giu_19) <- c("B2", "B3", "B4", "B8", "B12")
names(str_ago_19) <- c("B2", "B3", "B4", "B8", "B12")
names(str_giu_20) <- c("B2", "B3", "B4", "B8", "B12")
```

Di seguito vengono plottati i confronti in canali RGB reali e falsi colori per valutare visivamente l'impatto macroscopico dell'eruzione e delle aree bruciate sui versanti sud-occidentali dell'isola[cite: 1].

```r
# Visualizzazione in colori reali (True Color - RGB 3,2,1)
par(mfrow = c(1, 3), mar = c(3, 3, 4, 2))
plotRGB(str_giu_19, r=3, g=2, b=1, stretch="lin", main="Giugno 2019 (Pre)")
plotRGB(str_ago_19, r=3, g=2, b=1, stretch="lin", main="Agosto 2019 (Post)")
plotRGB(str_giu_20, r=3, g=2, b=1, stretch="lin", main="Giugno 2020 (Recupero)")
```

<img width="480" height="480" alt="true_color_confronto" src="https://github.com/user-attachments/assets/a84a3075-6c45-4894-988f-442b162d60ab" />


```r
# Visualizzazione in falsi colori (Near InfraRed sul canale del Rosso - RGB 4,3,2)
par(mfrow = c(1, 3), mar = c(3, 3, 4, 2))
plotRGB(str_giu_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2019")
plotRGB(str_ago_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Agosto 2019")
plotRGB(str_giu_20, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2020")
```
![](immagini%20progetto%20stromboli/false_color_confronto.png)

Dall'analisi a falsi colori si evince chiaramente come il rosso brillante (indice di forte riflettanza nel NIR dovuto alla presenza di clorofilla attiva) che caratterizza l'isola a giugno 2019 collassi vistosamente nella scena di agosto, lasciando spazio a toni scuri e opachi nelle aree percorse dal fuoco, per poi accennare a una parziale ripresa a macchie nel giugno del 2020.

---

## Analisi del Vigore Vegetazionale (DVI, NDVI, SAVI)

Applichiamo i tre principali indici spettrali per la vegetazione per mappare la perdita di vigore e le successive risposte multitemporali.

```r
# CALCOLO E CONFRONTO DEL DIFFERENCE VEGETATION INDEX (DVI)
dvi_giu_19 <- str_giu_19[["B8"]] - str_giu_19[["B4"]]
dvi_ago_19 <- str_ago_19[["B8"]] - str_ago_19[["B4"]]
dvi_giu_20 <- str_giu_20[["B8"]] - str_giu_20[["B4"]]

# Delta indici per studiare l impatto e il trend annuale
ddvi_19    <- dvi_giu_19 - dvi_ago_19  
ddvi_20    <- dvi_ago_19 - dvi_giu_20  
ddvi_netto <- dvi_giu_19 - dvi_giu_20  

# Visualizzazione dell impatto immediato sul DVI
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(dvi_giu_19, col = cividis(100), main = "DVI Giugno 2019 (Pre)")
plot(dvi_ago_19, col = cividis(100), main = "DVI Agosto 2019 (Post)")
plot(ddvi_19, col = turbo(100), main = "Delta DVI (Impatto 2019)")
```
![](immagini%20progetto%20stromboli/dvi_impatto_2019.png)

```r
# CALCOLO E CONFRONTO DEL NORMALIZED DIFFERENCE VEGETATION INDEX (NDVI)
ndvi_giu_19 <- (str_giu_19[["B8"]] - str_giu_19[["B4"]]) / (str_giu_19[["B8"]] + str_giu_19[["B4"]])
ndvi_ago_19 <- (str_ago_19[["B8"]] - str_ago_19[["B4"]]) / (str_ago_19[["B8"]] + str_ago_19[["B4"]])
ndvi_giu_20 <- (str_giu_20[["B8"]] - str_giu_20[["B4"]]) / (str_giu_20[["B8"]] + str_giu_20[["B4"]])

dndvi_19    <- ndvi_giu_19 - ndvi_ago_19  
dndvi_20    <- ndvi_ago_19 - ndvi_giu_20  
dndvi_netto <- ndvi_giu_19 - ndvi_giu_20  

# Visualizzazione del bilancio netto annuale dell NDVI (Giugno vs Giugno)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(ndvi_giu_19, col = mako(100), main = "NDVI Giugno 2019 (Pre)")
plot(ndvi_giu_20, col = mako(100), main = "NDVI Giugno 2020 (Recupero)")
plot(dndvi_netto, col = turbo(100), main = "Delta NDVI Netto (Annuale)")
```
![](immagini%20progetto%20stromboli/ndvi_bilancio_annuale.png)

```r
# CALCOLO DEL SOIL ADJUSTED VEGETATION INDEX (SAVI) WITH L=0.5
savi_giu_19 <- ((str_giu_19[["B8"]] - str_giu_19[["B4"]]) / (str_giu_19[["B8"]] + str_giu_19[["B4"]] + 0.5)) * (1 + 0.5)
savi_ago_19 <- ((str_ago_19[["B8"]] - str_ago_19[["B4"]]) / (str_ago_19[["B8"]] + str_ago_19[["B4"]] + 0.5)) * (1 + 0.5)
savi_giu_20 <- ((str_giu_20[["B8"]] - str_giu_20[["B4"]]) / (str_giu_20[["B8"]] + str_giu_20[["B4"]] + 0.5)) * (1 + 0.5)

dsavi_19    <- savi_giu_19 - savi_ago_19  
dsavi_20    <- savi_ago_19 - savi_giu_20  
dsavi_netto <- savi_giu_19 - savi_giu_20  
```

Mentre l'NDVI normalizza ottimamente l'effetto del rilievo topografico tipico di uno stratovulcano, l'introduzione del SAVI con un fattore di correzione del fondo $L = 0.5$ si rivela ideale in questo contesto d'esame. Il SAVI riesce infatti ad abbattere il rumore spettrale di fondo indotto dalla cenere vulcanica fine e dal terreno roccioso nudo, isolando il reale segnale fogliare residuo anche laddove la vegetazione è molto rada.

---

## Mappatura della Severità degli Incendi (NBR)

L'indice NBR, combinando la risposta del vicino infrarosso (NIR) e dello short-wave infrared (SWIR), rappresenta lo standard geologico per valutare la severità del danno da fuoco sul suolo e sulla biomassa[cite: 1].

```r
# CALCOLO E CONFRONTO DEL NORMALIZED BURN RATIO (NBR)
nbr_giu_19 <- (str_giu_19[["B8"]] - str_giu_19[["B12"]]) / (str_giu_19[["B8"]] + str_giu_19[["B12"]])
nbr_ago_19 <- (str_ago_19[["B8"]] - str_ago_19[["B12"]]) / (str_ago_19[["B8"]] + str_ago_19[["B12"]])
nbr_giu_20 <- (str_giu_20[["B8"]] - str_giu_20[["B12"]]) / (str_giu_20[["B8"]] + str_giu_20[["B12"]])

dnbr_19    <- nbr_giu_19 - nbr_ago_19  
dnbr_20    <- nbr_ago_19 - nbr_giu_20  
dnbr_netto <- nbr_giu_19 - nbr_giu_20  

# Visualizzazione della mappa differenziale dNBR 2019
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(nbr_giu_19, col = rocket(100), main = "NBR Giugno 2019 (Pre)")
plot(nbr_ago_19, col = rocket(100), main = "NBR Agosto 2019 (Post)")
plot(dnbr_19, col = turbo(100), main = "Delta NBR (dNBR 2019)")
```
![](immagini%20progetto%20stromboli/nbr_impatto_2019.png)

La mappa differenziale del `dnbr_19` evidenzia con precisione la severità dei macro-incendi indotti dal parossismo: il danno maggiore si concentra sul versante sud-ovest (sopra l'abitato di Ginostra) e lungo i costoni meridionali, validando spazialmente le aree ad alto impatto descritte nella letteratura scientifica di riferimento[cite: 1].

---

## Analisi Geologica Dedicata: Ferrous Iron Index

In questa sezione andiamo a valutare l'arricchimento e lo spostamento spettrale dei minerali di ferro (ossidi e silicati ferrosi tipici dei prodotti basaltici freschi) per tracciare la distribuzione dei prodotti d'esplosione accumulati sulla Sciara del Fuoco.

```r
# CALCOLO E MAPPARE DEI MINERALI FERROSI TRAMITE BAND RATIO SWIR/NIR
ferrous_giu_19 <- str_giu_19[["B12"]] / str_giu_19[["B8"]]
ferrous_ago_19 <- str_ago_19[["B12"]] / str_ago_19[["B8"]]

# Tronchiamo gli outlier spettrali per ottimizzare il contrasto visivo sulla roccia
limiti_ferrous <- quantiles(c(ferrous_giu_19, ferrous_ago_19), probs = c(0.005, 0.995))

# Visualizzazione comparativa pre e post eruzione
par(mfrow = c(1, 2), mar = c(4, 3, 4, 5))
plot(ferrous_giu_19, col = mako(100), range = limiti_ferrous, main = "Minerali Ferrosi - Giugno 2019 (Pre)")
plot(ferrous_ago_19, col = mako(100), range = limiti_ferrous, main = "Minerali Ferrosi - Agosto 2019 (Post)")
```
![](immagini%20progetto%20stromboli/geologia_ferrous_minerals_confronto.png)

Dal punto di vista dell'analisi geologica spettrale, il Ferrous Iron Index mostra una variazione netta in corrispondenza della Sciara del Fuoco e dei costoni sommitali. L'incremento dei valori ad agosto 2019 testimonia la messa in posto di piroclasti freschi, scorie litoidi e ceneri d'esplosione ricche in ferro non alterato, offrendo un livello d'informazione composizionale che i normali indici vegetazionali non sono in grado di rilevare.

---

## Classificazione Maschere e Mappe Ternarie Dinamiche (NDWI + NDVI)

Per evitare l'errore sistematico indotto dai basalti neri della Sciara (scambiati per mare dall'NDVI), utilizziamo l'indice idrico NDWI per estrarre geometricamente lo sfondo oceanico in modo stabile su tutte e tre le scene[cite: 1].

```r
# CALCOLO DELLE SOGLIE IDRICHE NORMALIZZATE
ndwi_giu19 <- (str_giu_19[["B3"]] - str_giu_19[["B8"]]) / (str_giu_19[["B3"]] + str_giu_19[["B8"]])
ndwi_ago19 <- (str_ago_19[["B3"]] - str_ago_19[["B8"]]) / (str_ago_19[["B3"]] + str_ago_19[["B8"]])
ndwi_giu20 <- (str_giu_20[["B3"]] - str_giu_20[["B8"]]) / (str_giu_20[["B3"]] + str_giu_20[["B8"]])

# CONDIZIONI LOGICHE DIRETTE SULLE CLASSI (STILE LEZIONE)
mare_giu19  <- ndwi_giu19 > 0
veg_giu19   <- ndvi_giu_19 > 0.27
suolo_giu19 <- ndwi_giu19 <= 0 & ndvi_giu_19 <= 0.27

mare_ago19  <- ndwi_ago19 > 0
veg_ago19   <- ndvi_ago_19 > 0.27
suolo_ago19 <- ndwi_ago19 <= 0 & ndvi_ago_19 <= 0.27

mare_giu20  <- ndwi_giu20 > 0
veg_giu20   <- ndvi_giu_20 > 0.27
suolo_giu20 <- ndwi_giu20 <= 0 & ndvi_giu_20 <= 0.27

# COSTRUZIONE DELLE MAPPE TERNARIE DISCRETE TRAMITE SOSTITUZIONE DIRETTA []
clas_giu19 <- ndvi_giu_19
clas_giu19[mare_giu19]  <- 1  # ID 1 = Mare
clas_giu19[suolo_giu19] <- 2  # ID 2 = Suolo Nudo / Cenere
clas_giu19[veg_giu19]   <- 3  # ID 3 = Vegetazione

clas_ago19 <- ndvi_ago_19
clas_ago19[mare_ago19]  <- 1
clas_ago19[suolo_ago19] <- 2
clas_ago19[veg_ago19]   <- 3

clas_giu20 <- ndvi_giu_20
clas_giu20[mare_giu20]  <- 1
clas_giu20[suolo_giu20] <- 2
clas_giu20[veg_giu20]   <- 3

# Visualizzazione delle mappe discrete stabili con palette cividis a 3 colori
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(clas_giu19, col = cividis(3), main = "Mappa Ternaria Giugno 2019 (Pre)")
plot(clas_ago19, col = cividis(3), main = "Mappa Ternaria Agosto 2019 (Post)")
plot(clas_giu20, col = cividis(3), main = "Mappa Ternaria Giugno 2020 (Recupero)")
```
![](immagini%20progetto%20stromboli/classificazione_ternaria_confronto.png)

La riclassificazione integrata NDWI-NDVI isola in modo impeccabile la silhouette dell'isola. La Sciara del Fuoco viene trattenuta correttamente all'interno della classe 2 (Suolo Nudo/Cenere), azzerando le fluttuazioni radiometriche e l'effetto binario errato riscontrato nei tentativi precedenti.

---

## Analisi Statistica delle Percentuali e Grafico di ggplot2

Eseguiamo l'estrazione geometrica delle frequenze dei pixel escludendo la classe Mare (ID 1), calcolando così le reali quote percentuali di copertura riferite esclusivamente alla terraferma dell'isola.

```r
# Estrazione delle frequenze dei pixel in console
freq_giu19 <- freq(clas_giu19)
freq_ago19 <- freq(clas_ago19)
freq_giu20 <- freq(clas_giu20)

# Somma dei pixel della sola isola (Suolo + Vegetazione)
isola_giu19 <- freq_giu19$count[2] + freq_giu19$count[3]
isola_ago19 <- freq_ago19$count[2] + freq_ago19$count[3]
isola_giu20 <- freq_giu20$count[2] + freq_giu20$count[3]

# Calcolo aritmetico delle percentuali di terraferma
perc_suolo_giu19 <- freq_giu19$count[2] * 100 / isola_giu19
perc_veg_giu19   <- freq_giu19$count[3] * 100 / isola_giu19

perc_suolo_ago19 <- freq_ago19$count[2] * 100 / isola_ago19
perc_veg_ago19   <- freq_ago19$count[3] * 100 / isola_ago19

perc_suolo_giu20 <- freq_giu20$count[2] * 100 / isola_giu20
perc_veg_giu20   <- freq_giu20$count[3] * 100 / isola_giu20

# Compilazione del data frame strutturato per il report
tabella_stromboli <- data.frame(
  Classe = c("Non vegetazione", "Vegetazione"),
  Pre_parossismo = round(c(perc_suolo_giu19, perc_veg_giu19), 2),
  Post_parossismo = round(c(perc_suolo_ago19, perc_veg_ago19), 2),
  Recupero_2020 = round(c(perc_suolo_giu20, perc_veg_giu20), 2)
)
```

### Tabella dei Risultati di Copertura dell'Isola (%)
| Classe | Pre_parossismo (Giu 19) | Post_parossismo (Ago 19) | Recupero_2020 (Giu 20) |
| :--- | :---: | :---: | :---: |
| **Non vegetazione** | 64.21 | 91.93 | 74.82 |
| **Vegetazione** | 35.79 | 8.07 | 25.18 |

Convertiamo ora il dataset in formato lungo tramite `melt()` per plottare le barre affiancate comparative con `ggplot2`.

```r
# Riorganizzazione del dataset per la struttura geometrica di ggplot
df_long <- melt(tabella_stromboli, id.vars = "Classe", variable.name = "Periodo", value.name = "Percentuale")

# COSTRUZIONE DEL GRAFICO COMPARATIVO CON GGPLOT2

# Associa le variabili del dataset lungo agli assi e alla scomposizione dei colori
grafico_copertura <- ggplot(df_long, aes(x = Classe, y = Percentuale, fill = Periodo)) +                                       
  
  # Evita il conteggio automatico dei record per usare direttamente i valori numerici della tabella
  geom_bar(stat = "identity", position = "dodge") +                                                                           
  
  # Posiziona le etichette numeriche sopra il baricentro di ciascuna barra scorporata
  geom_text(aes(label = round(Percentuale, 1)), position = position_dodge(width = 0.9), vjust = -0.25, size = 3) +             
  
  # Applica codici esadecimali personalizzati per bloccare la palette cromatica
  scale_fill_manual(values = c("Pre_parossismo" = "#0B0425", "Post_parossismo" = "#357BA2", "Recupero_2020" = "#DEF5E5")) +
  
  # Standardizza l'estensione verticale per facilitare il confronto visivo tra le classi
  ylim(0, 100) +
  
  # Definisce le stringhe di testo per i metadati grafici e la legenda degli assi
  labs(title = "Evoluzione della copertura del suolo a Stromboli (NDVI > 0.27)", y = "Percentuale (%)", x = "Classe di Copertura") +
  
  # Rimuove lo sfondo grigio di default isolando solo la griglia cartesiana essenziale
  theme_minimal()

print(grafico_copertura)
```
![](immagini%20progetto%20stromboli/grafico_barre_confronto.png)

I dati numerici estratti mostrano uno scenario macroscopico: a causa dell'eruzione e degli incendi del luglio 2019, la copertura vegetale reale dell'isola crolla verticalmente dal **35.79%** a un esiguo **8.07%**, registrando un aumento simmetrico della classe suolo nudo/cenere che sale al **91.93%**[cite: 1]. I dati inediti di giugno 2020 mostrano tuttavia una decisa inversione di tendenza: a meno di un anno dall'evento, la vegetazione pioniera risale fino al **25.18%**, confermando lo straordinario dinamismo e la resilienza ecologica degli ecosistemi insulari vulcanici[cite: 1].

---

## Analisi Statistica della Densità di Distribuzione (Ridgeline Plot)

In quest'ultima sezione uniamo i layer multitemporali in un unico stack continuo ed applichiamo il mascheramento NDWI per smussare le distribuzioni di frequenza spettrale, eliminando il rumore dell'acqua profonda.

```r
# PRODUZIONE DI UN RIDGELINE PLOT

# Creazione dello stack invertendo l'ordine dei layer per visualizzare Pre, Post e Recupero dall'alto verso il basso
ndvi_stack <- c(ndvi_giu_20, ndvi_ago_19, ndvi_giu_19)
names(ndvi_stack) <- c("NDVI_Giu20_Recupero", "NDVI_Ago19_Post", "NDVI_Giu19_Pre")

# Mascheriamo lo stack escludendo i pixel di mare (NDWI > 0) per ripulire le distribuzioni sulla sola terraferma
ndvi_stack_isola <- ndvi_stack
ndvi_stack_isola[ndwi_giu19 > 0] <- NA

# Generazione del ridgeline plot pulito sulla sola terraferma con palette inferno discreta
im.ridgeline(ndvi_stack_isola, scale = 1, palette = "inferno")
```
![](immagini%20progetto%20stromboli/grafico_ridgeline_ndvi.png)

Il grafico a cresta evidenzia in modo continuo la destrutturazione e il successivo riallineamento delle curve di densità dell'NDVI. La curva iniziale di giugno 2019, estesa verso valori medio-alti di vigore vegetativo, subisce uno slittamento drastico verso sinistra (valori vicini allo zero) ad agosto 2019, descrivendo l'omogeneizzazione spettrale indotta dalla cenere e dal passaggio del fuoco[cite: 1]. Nel giugno 2020, la forma d'onda si allarga nuovamente verso destra, confermando graficamente la ricolonizzazione in atto della flora strombolana[cite: 1].

---

## Conclusioni
L'analisi telerilevata multitemporale condotta tramite dati Sentinel-2 ha permesso di quantificare in modo preciso e solido l'impatto ecologico del parossismo del 3 luglio 2019 e la successiva evoluzione a breve termine dell'isola di Stromboli[cite: 1]. L'approccio basato sul mascheramento NDWI ha risolto i limiti classici di classificazione sui suoli scuri basaltici, mentre l'estensione dell'indagine al 2020 ha documentato un vigoroso processo di ripresa della copertura vegetale, che in soli dieci mesi ha recuperato oltre il 17% della superficie emersa dell'isola, ponendo basi importanti per la valutazione della resilienza e della gestione dei rischi ambientali secondari in aree vulcaniche attive[cite: 1].
