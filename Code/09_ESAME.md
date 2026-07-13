# Analisi Temporale Pre e Post Eruzione sull'Isola di Stromboli

## 1. Introduzione

Il telerilevamento satellitare è una disciplina che permette l’osservazione di aree molto estese o difficilmente accessibili della superficie terrestre, 
caratterizzate da diverse risoluzioni spaziali e in tempi relativamente brevi. Negli ultimi 30 anni, i progressi tecnologici hanno consentito l’applicazione di
questa disciplina allo studio delle calamità naturali e, in particolare, alla riduzione dell’esposizione della popolazione ai rischi legati agli incendi
(Iacono et al., 2025).

Il presente lavoro si inserisce in questo ambito e ha per oggetto l'isola di Stromboli (Isole Eolie), colpita il 3 luglio 2019 da un violento parossismo che ha
innescato numerosi incendi sui fianchi del vulcano. L'obiettivo di questo progetto è quantificare, attraverso indici spettrali derivati da immagini Sentinel-2, 
l'impatto immediato dell'evento sulla vegetazione dell'isola e valutarne il recupero nel medio termine, confrontando tre acquisizioni: giugno 2019 (condizione
pre-parossismo), agosto 2019 (condizione immediatamente successiva agli incendi) e giugno 2020 (a un anno di distanza, come verifica del recupero). A tal fine 
sono stati calcolati e confrontati gli indici DVI, NDVI e NBR, ed è stata condotta una classificazione della copertura del suolo per stimare le variazioni 
percentuali di superficie vegetata.

## 2. Inquadramento geologico e il caso studio del 2019

Stromboli è l'isola vulcanica più settentrionale dell'arcipelago delle Eolie, in Sicilia, e rappresenta la porzione emersa di un edificio vulcanico che si
estende fino a 1500-2600 m sotto il livello del mare; la sua cima, il Vancori, raggiunge i 924 m s.l.m., mentre l'attività eruttiva si concentra nella terrazza
craterica, situata nella parte sommitale della Sciara del Fuoco (Carapezza et al., 2009).

<img width="711" height="632" alt="mappa_geologica_stromboli" src="https://github.com/user-attachments/assets/6ba55bc4-19f1-46ca-bfce-0d75f9fde615" />

Fig. 1. Carta strutturale schematica di Stromboli (Carapezza et al., 2009) 

L'attività ordinaria del vulcano, detta "stromboliana", consiste in esplosioni brevi, ricorrenti e di modesta energia; essa può occasionalmente essere 
interrotta da colate laviche, esplosioni maggiori e parossismi, questi ultimi rappresentando le manifestazioni più pericolose dell'attività vulcanica 
dell'isola. Associate alle colonne eruttive sono associate piogge di clasti balistici (blocchi e bombe) che, possono appicare incendi che si propagano
nella macchia mediterranea dell'isola.
Questo fenomeno è documentato più volte nella storia recente dell'isola (1930, 1943 e 1950) e si è ripetuto nell'estate 2019 (Iacono et al., 2025).

Il parossismo del 3 luglio 2019 è iniziato nel primo pomeriggio con un'esplosione improvvisa che ha causato la ricaduta di scorie incandescenti fino al'abitato
di Stromboli e in direzione Ginostra. È seguita una colonna eruttiva alta 6-8 km, mentre due colate piroclastiche sono scese lungo la Sciara del Fuoco 
innescando piccoli maremoti al loro ingresso in mare. 
Gli incendi provocati dal materiale incandescente hanno interessato soprattutto il settore meridionale dell'isola, propagandosi fino a Ginostra dove hanno 
distrutto la centrale elettrica e causato la morte di una persona.

## 3.1 Metodi

Le immagini satellitari Sentinel-2 impiegate in questo lavoro sono state reperite manualmente attraverso il Copernicus Browser dell'ESA.
Questa scelta è stata motivata da due esigenze: da un lato, le indagini richiedevano acquisizioni puntuali e circoscritte a finestre temporali molto ristrette
(pre-parossismo, immediatamente post-parossismo, a un anno di distanza), per cui un prodotto mediato su più immagini, come tipicamente restituito da GEE, 
avrebbe potuto diluire o mascherare il segnale d'interesse; dall'altro, trattandosi di un vulcano attivo, le condizioni di copertura nuvolosa nelle fasi 
successive a un'eruzione sono spesso sfavorevoli, ed era quindi necessario poter scegliere manualmente le immagini con la minore copertura 
nuvolosa sull'area di interesse e avere maggiore flessibilità nella selezione delle bande da scaricare per poter testare numerosi indici spettrale.

L'elaborazione dei dati è stata condotta interamente in ambiente R, utilizzando funzioni di R base insieme ai seguenti pacchetti:

```r
library(terra)      # Pacchetto principale per lavorare con raster e immagini satellitari
library(viridis)    # 8 color scales adatte anche a utenti con daltonismo
library(ggplot2)    # Per la creazione di grafici
library(reshape2)   # Riorganizzare i dati nei dataframes
```

Gli indici spettrali calcolati e confrontati sono i seguenti:

- **DVI (Difference Vegetation Index)** — differenza semplice tra riflettanza nel NIR e nel Rosso (B8 − B4); fornisce un'indicazione grezza, non normalizzata,
  del vigore vegetativo.
- **NDVI (Normalized Difference Vegetation Index)** — versione normalizzata del DVI, (B8 − B4)/(B8 + B4); è l'indice standard per la stima della salute e
  densità della vegetazione, con valori teorici compresi tra -1 e 1.
- **NBR (Normalized Burn Ratio)** — (B8 − B12)/(B8 + B12), basato sul contrasto tra NIR e SWIR; è particolarmente sensibile alle superfici bruciate e alla
  cenere, che assorbono meno nel SWIR rispetto alla vegetazione sana.
- **NDWI (Normalized Difference Water Index)** — (B3 − B8)/(B3 + B8); in questo lavoro è stato utilizzato non per una vera e propria caratterizzazione
  idrologica, ma con la funzione operativa di isolare i pixel di mare, così da poterli escludere (o gestire come classe a sé) nella successiva classificazione
  ternaria dell'isola.

## 4. Preparazione del materiale

Per ciascuna delle tre date (giugno 2019, agosto 2019, giugno 2020) sono state caricate le bande a 10 m di risoluzione (B2 - Blu, B3 - Verde, B4 - Rosso, B8 - NIR) e la banda B12 (SWIR) a 20 m di risoluzione:

```r
# IMPOSTAZIONE WORKSPACE E CARICAMENTO BANDE A 10 METRI (E 20 METRI PER B12)

# Configurazione della cartella principale di lavoro (Working Directory)
setwd("C:/Users/User/Desktop/telerilevamento in R/progetto esame Stromboli")

# GIUGNO - PRE
b2_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B02_10m.jp2")
b3_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B03_10m.jp2")
b4_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B04_10m.jp2")
b8_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B08_10m.jp2")
# Caricamento della Banda 12 (SWIR) a 20 metri per Giugno 2019
b12_giu19 <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R20m/T33SWC_20190607T095031_B12_20m.jp2")

# AGOSTO - POST
b2_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B02_10m.jp2")
b3_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B03_10m.jp2")
b4_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B04_10m.jp2")
b8_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B08_10m.jp2")
# Caricamento della Banda 12 (SWIR) a 20 metri per Agosto 2019
b12_ago19 <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R20m/T33SWC_20190811T095039_B12_20m.jp2")

# GIUGNO 2020 - RECUPERO (?)
b2_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B02_10m.jp2")
b3_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B03_10m.jp2")
b4_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B04_10m.jp2")
b8_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R10m/T33SWD_20200626T095029_B08_10m.jp2")
# Caricamento della Banda 12 (SWIR) a 20 metri per Giugno 2020
b12_giu20 <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R20m/T33SWD_20200626T095029_B12_20m.jp2")
```

Prima di procedere, è stata verificata la coerenza spaziale (sistema di riferimento ed estensione) tra le tre acquisizioni, condizione necessaria per un confronto multitemporale corretto:

```r
# Confrontiamo giugno, agosto e giugno 2020 per essere sicuri che le tre immagini siano proiettate nello stesso
# sistema di riferimento e che si sovrappongano alla perfezione

crs(b2_giu19)
# "PROJCRS[\"WGS 84 / UTM zone 33N\",\n
crs(b2_ago19) 
# "PROJCRS[\"WGS 84 / UTM zone 33N\",\n
crs(b2_giu20)
# "PROJCRS[\"WGS 84 / UTM zone 33N\",\n

ext(b2_giu19)
# SpatExtent : 499980, 609780, 4190220, 4300020 (xmin, xmax, ymin, ymax)
ext(b2_ago19)
# SpatExtent : 499980, 609780, 4190220, 4300020 (xmin, xmax, ymin, ymax)
ext(b2_giu20)
# SpatExtent : 499980, 609780, 4190220, 4300020 (xmin, xmax, ymin, ymax)
```

Confermata la coerenza spaziale, è stata definita un'estensione ridotta intorno all'isola per il ritaglio (crop) di tutte le bande; la banda B12, nativa a 20 m, è stata inoltre ricampionata con metodo bilineare sulla griglia a 10 m delle altre bande, in modo da ottenere stack multibanda omogenei:

```r
# DEFINIZIONE ESTENSIONE E RITAGLIO (CROP)

# Ordine richiesto dalla funzione ext(): xmin, xmax, ymin, ymax
estensione_stromboli <- ext(515715, 521500, 4291265, 4296385)

# RITAGLIO (CROP) DI TUTTE LE BANDE DI GIUGNO 2019
b2_giu19_crop <- crop(b2_giu19, estensione_stromboli)
b3_giu19_crop <- crop(b3_giu19, estensione_stromboli)
b4_giu19_crop <- crop(b4_giu19, estensione_stromboli)
b8_giu19_crop <- crop(b8_giu19, estensione_stromboli)
# Ritaglio e ricampionamento della Banda 12 sulla griglia a 10m (B2) per Giugno 2019
b12_giu19_crop <- resample(crop(b12_giu19, estensione_stromboli), b2_giu19_crop, method="bilinear")

# RITAGLIO (CROP) DI TUTTE LE BANDE DI AGOSTO 2019
b2_ago19_crop <- crop(b2_ago19, estensione_stromboli)
b3_ago19_crop <- crop(b3_ago19, estensione_stromboli)
b4_ago19_crop <- crop(b4_ago19, estensione_stromboli)
b8_ago19_crop <- crop(b8_ago19, estensione_stromboli)
# Ritaglio e ricampionamento della Banda 12 sulla griglia a 10m (B2) per Agosto 2019
b12_ago19_crop <- resample(crop(b12_ago19, estensione_stromboli), b2_ago19_crop, method="bilinear")

# RITAGLIO (CROP) DI TUTTE LE BANDE DI GIUGNO 2020
b2_giu20_crop <- crop(b2_giu20, estensione_stromboli)
b3_giu20_crop <- crop(b3_giu20, estensione_stromboli)
b4_giu20_crop <- crop(b4_giu20, estensione_stromboli)
b8_giu20_crop <- crop(b8_giu20, estensione_stromboli)
# Ritaglio e ricampionamento della Banda 12 sulla griglia a 10m (B2) per Giugno 2020
b12_giu20_crop <- resample(crop(b12_giu20, estensione_stromboli), b2_giu20_crop, method="bilinear")
```

Infine, le bande ritagliate sono state unite in tre stack multibanda (uno per data), con i livelli rinominati per rendere il codice successivo più leggibile:

```r
# CREAZIONE DEGLI STACK MULTI-BANDA E VISUALIZZAZIONE RGB

# Uniamo le bande nell'ordine: B2 (1), B3 (2), B4 (3), B8 (4), B12 (5)
str_giu_19 <- c(b2_giu19_crop, b3_giu19_crop, b4_giu19_crop, b8_giu19_crop, b12_giu19_crop)
str_ago_19 <- c(b2_ago19_crop, b3_ago19_crop, b4_ago19_crop, b8_ago19_crop, b12_ago19_crop)
str_giu_20 <- c(b2_giu20_crop, b3_giu20_crop, b4_giu20_crop, b8_giu20_crop, b12_giu20_crop)

# Controllo veloce della struttura dello stack in console
str_giu_19
str_ago_19
str_giu_20

# Rinominiamo i livelli degli stack per rendere il codice pulito e comprensibile
names(str_giu_19) <- c("B2", "B3", "B4", "B8", "B12")
names(str_ago_19) <- c("B2", "B3", "B4", "B8", "B12")
names(str_giu_20) <- c("B2", "B3", "B4", "B8", "B12")
```

## 5. Visualizzazione e confronto delle bande spettrali

Prima di procedere al calcolo degli indici, le bande sono state visualizzate singolarmente e in composizione RGB (vero colore e falso colore), sia come controllo qualitativo sui dati sia per evidenziare in modo diretto le differenze tra le tre date.

### 5.1 Bande singole — Giugno 2019 (pre-parossismo)

```r
# ViSUALIZZAZIONE E ESPORTAZIONE DELLE BANDE
png("immagini progetto stromboli/bande_str_giu_19.png", width = 12, height = 8, units = "in", res = 300)
plot(str_giu_19, col=plasma(100))
dev.off()
```

**[INSERISCI QUI: `bande_str_giu_19.png`]**

```r
png("immagini progetto stromboli/bande_separate_giu19.png", width = 12, height = 8, units = "in", res = 300)
par(mfrow = c(2, 3), mar = c(4, 3, 4, 5))
plot(str_giu_19[["B2"]], col = plasma(100), main = "Blu (B2)")
plot(str_giu_19[["B3"]], col = plasma(100), main = "Verde (B3)")
plot(str_giu_19[["B4"]], col = plasma(100), main = "Rosso (B4)")
plot(str_giu_19[["B8"]], col = plasma(100), main = "NIR (B8)")
plot(str_giu_19[["B12"]], col = plasma(100), main = "SWIR (B12)")
dev.off()
```

**[INSERISCI QUI: `bande_separate_giu19.png`]**

*Nelle singole bande pre-parossismo la vegetazione dovrebbe risultare riconoscibile soprattutto dal contrasto tra Rosso e NIR.* **Completa qui con le osservazioni specifiche sulle tue immagini:** ______________________________

### 5.2 Bande singole — Agosto 2019 (post-parossismo)

```r
# AGO - 19
png("immagini progetto stromboli/bande_str_ago_19.png", width = 12, height = 8, units = "in", res = 300)
plot(str_ago_19, col=plasma(100))
dev.off()
```

**[INSERISCI QUI: `bande_str_ago_19.png`]**

```r
png("immagini progetto stromboli/bande_separate_ago19.png", width = 12, height = 8, units = "in", res = 300)
par(mfrow = c(2, 3), mar = c(4, 3, 4, 5))
plot(str_ago_19[["B2"]], col = plasma(100), main = "Blu (B2)")
plot(str_ago_19[["B3"]], col = plasma(100), main = "Verde (B3)")
plot(str_ago_19[["B4"]], col = plasma(100), main = "Rosso (B4)")
plot(str_ago_19[["B8"]], col = plasma(100), main = "NIR (B8)")
plot(str_ago_19[["B12"]], col = plasma(100), main = "SWIR (B12)")
dev.off()
```

**[INSERISCI QUI: `bande_separate_ago19.png`]**

*A seguito degli incendi ci si attende un aumento di riflettanza nel Rosso e nello SWIR nelle aree bruciate, e una riduzione nel NIR rispetto a giugno.* **Completa qui:** ______________________________

### 5.3 Bande singole — Giugno 2020 (recupero)

```r
# GIU - 20
png("immagini progetto stromboli/bande_str_giu_20.png", width = 12, height = 8, units = "in", res = 300)
plot(str_giu_20, col=plasma(100))
dev.off()
```

**[INSERISCI QUI: `bande_str_giu_20.png`]**

```r
png("immagini progetto stromboli/bande_separate_giu20.png", width = 12, height = 8, units = "in", res = 300)
par(mfrow = c(2, 3), mar = c(4, 3, 4, 5))
plot(str_giu_20[["B2"]], col = plasma(100), main = "Blu (B2)")
plot(str_giu_20[["B3"]], col = plasma(100), main = "Verde (B3)")
plot(str_giu_20[["B4"]], col = plasma(100), main = "Rosso (B4)")
plot(str_giu_20[["B8"]], col = plasma(100), main = "NIR (B8)")
plot(str_giu_20[["B12"]], col = plasma(100), main = "SWIR (B12)")
dev.off()
```

**[INSERISCI QUI: `bande_separate_giu20.png`]**

*A un anno di distanza ci si attende un parziale ritorno verso i valori pre-parossismo, senza necessariamente un recupero completo.* **Completa qui:** ______________________________

### 5.4 Composizioni RGB: vero colore e falso colore

```r
# VISUALIZZAZIONE IN COLORI REALI (True Color - RGB 3,2,1)
png("immagini progetto stromboli/true_color_confronto.png")
par(mfrow = c(1, 3), mar = c(3, 3, 4, 2))  # rendo l'immagine multiframe e sistemo i margini per ottimizzare la visualizzazione
plotRGB(str_giu_19, r=3, g=2, b=1, stretch="lin", main="Giugno 2019 (Pre)")
plotRGB(str_ago_19, r=3, g=2, b=1, stretch="lin", main="Agosto 2019 (Post)")
plotRGB(str_giu_20, r=3, g=2, b=1, stretch="lin", main="Giugno 2020 (Recupero)")
dev.off()
```

**[INSERISCI QUI: `true_color_confronto.png`]**

```r
# VISUALIZZAZIONE E ESPORTAZIONE IN FALSI COLORI (RGB 4,3,2)
png("immagini progetto stromboli/false_color_confronto.png")
par(mfrow = c(1, 3), mar = c(3, 3, 4, 2))
plotRGB(str_giu_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2019")
plotRGB(str_ago_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Agosto 2019")
plotRGB(str_giu_20, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2020")
dev.off() # Chiudere il pannello di Visualizzazione delle immagini e ristabilire il formato dei grafici a quello di default
```

**[INSERISCI QUI: `false_color_confronto.png`]**

*Nel falso colore (NIR-Rosso-Verde) la vegetazione sana appare tipicamente in tonalità rosse/rosate; una riduzione di queste tonalità tra giugno e agosto 2019 è il segnale atteso dell'impatto degli incendi.* **Completa qui:** ______________________________

### 5.5 Confronto diretto delle bande pre/post parossismo

```r
png("immagini progetto stromboli/confronto_bande_19_pre_post.png", width = 16, height = 8, units = "in", res = 300)
par(mfrow = c(2, 4), mar = c(4, 3, 4, 5)) # Dividiamo lo schermo in 2 righe (sopra Giugno, sotto Agosto) e 4 colonne (B2, B3, B4, B8)
# RIGA 1: Giugno 2019 (Pre-eruzione)
plot(str_giu_19[["B2"]], col = inferno(100), main = "Pre - Blu (B2)")
plot(str_giu_19[["B3"]], col = inferno(100), main = "Pre - Verde (B3)")
plot(str_giu_19[["B4"]], col = inferno(100), main = "Pre - Rosso (B4)")
plot(str_giu_19[["B8"]], col = inferno(100), main = "Pre - NIR (B8)")

# RIGA 2: Agosto 2019 (Post-eruzione)
plot(str_ago_19[["B2"]], col = inferno(100), main = "Post - Blu (B2)")
plot(str_ago_19[["B3"]], col = inferno(100), main = "Post - Verde (B3)")
plot(str_ago_19[["B4"]], col = inferno(100), main = "Post - Rosso (B4)")
plot(str_ago_19[["B8"]], col = inferno(100), main = "Post - NIR (B8)")
dev.off()
```

**[INSERISCI QUI: `confronto_bande_19_pre_post.png`]**

*Il confronto diretto per banda dovrebbe rendere più immediato individuare in quali bande (tipicamente B4 e B8) la differenza pre/post è più marcata.* **Completa qui:** ______________________________

## 6. Calcolo degli indici spettrali di vegetazione

Per ciascuna delle tre date sono stati calcolati gli indici DVI, NDVI e NBR, e per ciascun indice sono state calcolate tre differenze: l'impatto immediato del parossismo (giugno vs agosto 2019), il recupero a un anno (agosto 2019 vs giugno 2020) e il bilancio netto su base annuale (giugno 2019 vs giugno 2020).

### 6.1 DVI (Difference Vegetation Index)

```r
# CALCOLO DEGLI INDICI VEGETAZIONALI, DIFFERENZE E ESPORTAZIONE

# INDICE DVI (Difference Vegetation Index)

# Calcolo indici
dvi_giu_19 <- str_giu_19[["B8"]] - str_giu_19[["B4"]]
dvi_ago_19 <- str_ago_19[["B8"]] - str_ago_19[["B4"]]
dvi_giu_20 <- str_giu_20[["B8"]] - str_giu_20[["B4"]]

# Calcolo differenze
ddvi_19    <- dvi_giu_19 - dvi_ago_19  # Impatto immediato dell'eruzione
ddvi_20    <- dvi_ago_19 - dvi_giu_20  # Recupero post-evento
ddvi_netto <- dvi_giu_19 - dvi_giu_20  # Bilancio del danno netto a un anno
```

```r
# VISUALIZZAZIONE E ESPORTAZIONE DVI

# Grafico 1: Impatto Immediato DVI (2019)
png("immagini progetto stromboli/dvi_impatto_2019.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(dvi_giu_19, col = cividis(100), main = "DVI Giugno 2019 (Pre)")
plot(dvi_ago_19, col = cividis(100), main = "DVI Agosto 2019 (Post)")
plot(ddvi_19, col = colorRampPalette(c("grey", "black"))(100), main = "Delta DVI (Impatto 2019)")
dev.off()
```

**[INSERISCI QUI: `dvi_impatto_2019.png`]**

```r
# Grafico 2: Recupero DVI (2019 vs 2020)
png("immagini progetto stromboli/dvi_recupero_2020.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(dvi_ago_19, col = cividis(100), main = "DVI Agosto 2019 (Post)")
plot(dvi_giu_20, col = cividis(100), main = "DVI Giugno 2020 (Recupero)")
plot(ddvi_20, col = colorRampPalette(c("grey", "black"))(100), main = "Delta DVI (Recupero 19-20)")
dev.off()
```

**[INSERISCI QUI: `dvi_recupero_2020.png`]**

```r
# Grafico 3: Bilancio Netto Annuale DVI (Giugno vs Giugno)
png("immagini progetto stromboli/dvi_bilancio_annuale.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(dvi_giu_19, col = cividis(100), main = "DVI Giugno 2019 (Pre)")
plot(dvi_giu_20, col = cividis(100), main = "DVI Giugno 2020 (Recupero)")
plot(ddvi_netto, col = colorRampPalette(c("grey", "black"))(100), main = "Delta DVI Netto (Annuale)")
dev.off()
```

**[INSERISCI QUI: `dvi_bilancio_annuale.png`]**

*Non essendo normalizzato, il DVI va letto soprattutto in termini relativi tra le tre date piuttosto che in valore assoluto.* **Completa qui con il commento ai tre grafici DVI:** ______________________________

### 6.2 NDVI (Normalized Difference Vegetation Index)

```r
# INDICE NDVI (Normalized Difference Vegetation Index)

# Calcolo indici
ndvi_giu_19 <- (str_giu_19[["B8"]] - str_giu_19[["B4"]]) / (str_giu_19[["B8"]] + str_giu_19[["B4"]])
ndvi_ago_19 <- (str_ago_19[["B8"]] - str_ago_19[["B4"]]) / (str_ago_19[["B8"]] + str_ago_19[["B4"]])
ndvi_giu_20 <- (str_giu_20[["B8"]] - str_giu_20[["B4"]]) / (str_giu_20[["B8"]] + str_giu_20[["B4"]])

# Calcolo differenze
dndvi_19    <- ndvi_giu_19 - ndvi_ago_19  # Impatto immediato dell'eruzione[cite: 1]
dndvi_20    <- ndvi_ago_19 - ndvi_giu_20  # Recupero post-evento[cite: 1]
dndvi_netto <- ndvi_giu_19 - ndvi_giu_20  # Bilancio del vigore netto a un anno
```

```r
# VISUALIZZAZIONE E ESPORTAZIONE NDVI

# Grafico 1: Impatto Immediato NDVI (2019)
png("immagini progetto stromboli/ndvi_impatto_2019.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(ndvi_giu_19, col = mako(100), main = "NDVI Giugno 2019 (Pre)")
plot(ndvi_ago_19, col = mako(100), main = "NDVI Agosto 2019 (Post)")
plot(dndvi_19, col = colorRampPalette(c("grey", "black"))(100), main = "Delta NDVI (Impatto 2019)")
dev.off()
```

**[INSERISCI QUI: `ndvi_impatto_2019.png`]**

```r
# Grafico 2: Recupero NDVI (2019 vs 2020)
png("immagini progetto stromboli/ndvi_recupero_2020.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(ndvi_ago_19, col = mako(100), main = "NDVI Agosto 2019 (Post)")
plot(ndvi_giu_20, col = mako(100), main = "NDVI Giugno 2020 (Recupero)")
plot(dndvi_20, col = colorRampPalette(c("grey", "black"))(100), main = "Delta NDVI (Recupero 19-20)")
dev.off()
```

**[INSERISCI QUI: `ndvi_recupero_2020.png`]**

```r
# Grafico 3: Bilancio Netto Annuale NDVI (Giugno vs Giugno)
png("immagini progetto stromboli/ndvi_bilancio_annuale.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(ndvi_giu_19, col = mako(100), main = "NDVI Giugno 2019 (Pre)")
plot(ndvi_giu_20, col = mako(100), main = "NDVI Giugno 2020 (Recupero)")
plot(dndvi_netto, col = colorRampPalette(c("grey", "black"))(100), main = "Delta NDVI Netto (Annuale)")
dev.off()
```

**[INSERISCI QUI: `ndvi_bilancio_annuale.png`]**

*In letteratura, l'impatto degli incendi del 2019 su Stromboli è stato descritto come particolarmente marcato nei settori occidentale e sud-occidentale dell'isola (Iacono et al., 2025): è un utile riferimento per verificare se il pattern spaziale del tuo Delta NDVI vada nella stessa direzione.* **Completa qui:** ______________________________

### 6.3 NBR (Normalized Burn Ratio)

```r
# INDICE NBR (Normalized Burn Ratio)

# Calcolo indici
nbr_giu_19 <- (str_giu_19[["B8"]] - str_giu_19[["B12"]]) / (str_giu_19[["B8"]] + str_giu_19[["B12"]])
nbr_ago_19 <- (str_ago_19[["B8"]] - str_ago_19[["B12"]]) / (str_ago_19[["B8"]] + str_ago_19[["B12"]])
nbr_giu_20 <- (str_giu_20[["B8"]] - str_giu_20[["B12"]]) / (str_giu_20[["B8"]] + str_giu_20[["B12"]])

# Calcolo differenze
dnbr_19    <- nbr_giu_19 - nbr_ago_19  # Severità del danno immediata
dnbr_20    <- nbr_ago_19 - nbr_giu_20  # Attenuazione del danno
dnbr_netto <- nbr_giu_19 - nbr_giu_20  # Severità del danno permanente a un anno
```

```r
# VISUALIZZAZIONE E ESPORTAZIONE NBR

# Grafico 1: Impatto Immediato NBR (2019)
png("immagini progetto stromboli/nbr_impatto_2019.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(nbr_giu_19, col = rocket(100), main = "NBR Giugno 2019 (Pre)")
plot(nbr_ago_19, col = rocket(100), main = "NBR Agosto 2019 (Post)")
plot(dnbr_19, col = colorRampPalette(c("grey", "black"))(100), main = "Delta NBR (dNBR 2019)")
dev.off()
```

**[INSERISCI QUI: `nbr_impatto_2019.png`]**

```r
# Grafico 2: Recupero NBR (Agosto 2019 vs Giugno 2020)
png("immagini progetto stromboli/nbr_recupero_2020.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(nbr_ago_19, col = rocket(100), main = "NBR Agosto 2019 (Post)")
plot(nbr_giu_20, col = rocket(100), main = "NBR Giugno 2020 (Recupero)")
plot(dnbr_20, col = colorRampPalette(c("grey", "black"))(100), main = "Delta NBR (dNBR 19-20)")
dev.off()
```

**[INSERISCI QUI: `nbr_recupero_2020.png`]**

```r
# Grafico 3: Bilancio Netto Annuale NBR (Giugno 19 vs Giugno 20)
png("immagini progetto stromboli/nbr_bilancio_annuale.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(nbr_giu_19, col = rocket(100), main = "NBR Giugno 2019 (Pre)")
plot(nbr_giu_20, col = rocket(100), main = "NBR Giugno 2020 (Recupero)")
plot(dnbr_netto, col = colorRampPalette(c("grey", "black"))(100), main = "Delta NBR Netto (Annuale)")
dev.off()
```

**[INSERISCI QUI: `nbr_bilancio_annuale.png`]**

*Il NBR, sfruttando lo SWIR, dovrebbe evidenziare in modo più netto le aree effettivamente percorse dal fuoco (cenere/suolo esposto) rispetto al NDVI, che risente più in generale dello stato di salute della vegetazione.* **Completa qui:** ______________________________

## 7.1 Classificazione tramite maschera ternaria

Per ottenere una stima quantitativa (non solo qualitativa) dell'impatto sulla copertura del suolo, è stata costruita per ciascuna data una classificazione ternaria in tre classi — mare, suolo nudo/cenere, vegetazione — basata su semplici soglie applicate a NDWI e NDVI.

Il primo passo è stato calcolare l'NDWI su tutte e tre le date; come indicato in precedenza, il suo utilizzo qui non è finalizzato a una vera e propria caratterizzazione idrologica, ma esclusivamente a isolare i pixel di mare (valori di NDWI positivi) e poterli quindi trattare come classe a sé nella classificazione:

```r
# MASCHERE E MAPPE TERNARIE DI COPERTURA CON INDICI NORMALIZZATI E SINTASSI LEZIONE

# CALCOLO DELL INDICE IDRICO NDWI PER TUTTE E TRE LE DATE
ndwi_giu19 <- (str_giu_19[["B3"]] - str_giu_19[["B8"]]) / (str_giu_19[["B3"]] + str_giu_19[["B8"]])
ndwi_ago19 <- (str_ago_19[["B3"]] - str_ago_19[["B8"]]) / (str_ago_19[["B3"]] + str_ago_19[["B8"]])
ndwi_giu20 <- (str_giu_20[["B3"]] - str_giu_20[["B8"]]) / (str_giu_20[["B3"]] + str_giu_20[["B8"]])
```

Le tre classi sono state definite secondo la seguente logica: NDWI > 0 identifica il mare (l'acqua presenta valori positivi di NDWI, mentre la terraferma valori negativi); tra i pixel di terraferma, NDVI > 0.27 identifica la vegetazione, mentre i restanti pixel (NDWI ≤ 0 e NDVI ≤ 0.27) sono classificati come suolo nudo o cenere. La soglia di 0.27 sul NDVI è stata individuata empiricamente osservando la distribuzione dei valori sulla terraferma *(completa qui, se vuoi, con eventuali dettagli aggiuntivi sulla scelta della soglia: ______________________________)*:

```r
# CONDIZIONI LOGICHE E IDENTIFICAZIONE CLASSI STABILI
# L'acqua ha valori positivi di NDWI, la terraferma ha valori negativi

# GIUGNO 2019 PRE ERUZIONE
mare_giu19  <- ndwi_giu19 > 0
veg_giu19   <- ndvi_giu_19 > 0.27
suolo_giu19 <- ndwi_giu19 <= 0 & ndvi_giu_19 <= 0.27

# AGOSTO 2019 POST ERUZIONE
mare_ago19  <- ndwi_ago19 > 0
veg_ago19   <- ndvi_ago_19 > 0.27
suolo_ago19 <- ndwi_ago19 <= 0 & ndvi_ago_19 <= 0.27

# IMMAGINE DI GIUGNO 2020 RECUPERO
mare_giu20  <- ndwi_giu20 > 0
veg_giu20   <- ndvi_giu_20 > 0.27
suolo_giu20 <- ndwi_giu20 <= 0 & ndvi_giu_20 <= 0.27
```

Le tre classi (codificate 1 = mare, 2 = suolo, 3 = vegetazione) sono state quindi assegnate a una mappa derivata dall'NDVI:

```r
# CREAZIONE DELLA MAPPA TERNARIA

# Giugno 2019
clas_giu19 <- ndvi_giu_19
clas_giu19[mare_giu19]  <- 1  # ID 1 = Mare
clas_giu19[suolo_giu19] <- 2  # ID 2 = Suolo Nudo / Cenere
clas_giu19[veg_giu19]   <- 3  # ID 3 = Vegetazione

# Agosto 2019
clas_ago19 <- ndvi_ago_19
clas_ago19[mare_ago19]  <- 1
clas_ago19[suolo_ago19] <- 2
clas_ago19[veg_ago19]   <- 3

# Giugno 2020
clas_giu20 <- ndvi_giu_20
clas_giu20[mare_giu20]  <- 1
clas_giu20[suolo_giu20] <- 2
clas_giu20[veg_giu20]   <- 3
```

```r
# VISUALIZZAZIONE E ESPORTAZIONE MAPPE TERNARIE 1x3
png("immagini progetto stromboli/classificazione_ternaria_confronto.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(clas_giu19, col = cividis(3), main = "Mappa Ternaria Giugno 2019 (Pre)")
plot(clas_ago19, col = cividis(3), main = "Mappa Ternaria Agosto 2019 (Post)")
plot(clas_giu20, col = cividis(3), main = "Mappa Ternaria Giugno 2020 (Recupero)")
dev.off()
```

**[INSERISCI QUI: `classificazione_ternaria_confronto.png`]**

```r
# ESPORTAZIONE MASCHERE BINARIE SOLO VEGETAZIONE 1x3
png("immagini progetto stromboli/confronto_maschere_vegetazione.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(veg_giu19, col = gray.colors(2), main = "Vegetazione - Giugno 2019 (Pre)")
plot(veg_ago19, col = gray.colors(2), main = "Vegetazione - Agosto 2019 (Post)")
plot(veg_giu20, col = gray.colors(2), main = "Vegetazione - Giugno 2020 (Recupero)")
dev.off()
```

**[INSERISCI QUI: `confronto_maschere_vegetazione.png`]**

*Le mappe ternarie dovrebbero mostrare una netta espansione della classe "suolo nudo/cenere" ad agosto 2019, con parziale ritorno della classe "vegetazione" a giugno 2020; le maschere binarie isolano solo quest'ultimo cambiamento.* **Completa qui:** ______________________________

## 7.2 Percentuali di copertura sulla terraferma e Ridgeline plot

Per quantificare il cambiamento in termini percentuali, sono stati contati i pixel di ciascuna classe con la funzione `freq()`, ed è stata isolata la sola terraferma (classi "suolo" e "vegetazione", escludendo il mare) per calcolare le percentuali di suolo nudo e vegetazione rispetto alla sola superficie dell'isola:

```r
# FUNZIONE FREQ PER IL CALCOLO DEI PIXEL NELLE TRE DATE
freq_giu19 <- freq(clas_giu19)
freq_ago19 <- freq(clas_ago19)
freq_giu20 <- freq(clas_giu20)
```

```r
# ESTRAZIONE DEI CONTEGGI PURI PER ISOLARE LA TERRAFERMA ESCLUDENDO IL MARE
# ID 1 = Mare, ID 2 = Suolo, ID 3 = Vegetazione
isola_giu19 <- freq_giu19$count[2] + freq_giu19$count[3]
isola_ago19 <- freq_ago19$count[2] + freq_ago19$count[3]
isola_giu20 <- freq_giu20$count[2] + freq_giu20$count[3]

# CALCOLO DELLE PERCENTUALI REALI SULLA SUPERFICIE DELL ISOLA
perc_suolo_giu19 <- freq_giu19$count[2] * 100 / isola_giu19           # 64.21448
perc_veg_giu19   <- freq_giu19$count[3] * 100 / isola_giu19           # 35.78552

perc_suolo_ago19 <- freq_ago19$count[2] * 100 / isola_ago19           # 91.92919
perc_veg_ago19   <- freq_ago19$count[3] * 100 / isola_ago19           # 8.070809 

perc_suolo_giu20 <- freq_giu20$count[2] * 100 / isola_giu20           # 74.82413
perc_veg_giu20   <- freq_giu20$count[3] * 100 / isola_giu20           # 25.17587

tabella_stromboli <- data.frame(
  Classe = c("Non vegetazione", "Vegetazione"),
  Pre_parossismo = round(c(perc_suolo_giu19, perc_veg_giu19), 2),
  Post_parossismo = round(c(perc_suolo_ago19, perc_veg_ago19), 2),
  Recupero_2020 = round(c(perc_suolo_giu20, perc_veg_giu20), 2)
)
#    Classe              Pre_parossismo    Post_parossismo   Recupero_2020
#    Non vegetazione          64.21          91.93            74.82
#    Vegetazione              35.79          8.07             25.18

# ESPORTAZIONE DELLA TABELLA DATI IN FORMATO CSV
write.csv(tabella_stromboli, "immagini progetto stromboli/tabella_frequenze_copertura.csv", row.names = FALSE)
print(tabella_stromboli)
```

I valori risultanti sono riassunti nella tabella seguente:

| Classe | Pre-parossismo (giu 2019) | Post-parossismo (ago 2019) | Recupero (giu 2020) |
|---|---|---|---|
| Non vegetazione | 64,21 % | 91,93 % | 74,82 % |
| Vegetazione | 35,79 % | 8,07 % | 25,18 % |

I dati mostrano una riduzione della superficie vegetata dal 35,79% al 8,07% tra giugno e agosto 2019 (una perdita relativa di circa il 77% della vegetazione presente), seguita da un recupero parziale al 25,18% entro giugno 2020 — un valore ancora sensibilmente inferiore a quello pre-parossismo.

```r
# CONVERSIONE DELLA TABELLA PER GGPLOT2
df_long <- melt(tabella_stromboli, id.vars = "Classe", variable.name = "Periodo", value.name = "Percentuale")

# COSTRUZIONE DEL GRAFICO COMPARATIVO CON GGPLOT2
grafico_copertura <- ggplot(df_long, aes(x = Classe, y = Percentuale, fill = Periodo)) +                                               
  geom_bar(stat = "identity", position = "dodge") +                                                                                     
  geom_text(aes(label = round(Percentuale, 1)), position = position_dodge(width = 0.9), vjust = -0.25, size = 3) +                      
  scale_fill_manual(values = c("Pre_parossismo" = "#0B0425", "Post_parossismo" = "#357BA2", "Recupero_2020" = "#DEF5E5")) +
  ylim(0, 100) +
  labs(title = "Evoluzione della copertura del suolo a Stromboli (NDVI > 0.27)", y = "Percentuale (%)", x = "Classe di Copertura") +
  theme_minimal()

# ESPORTAZIONE E SALVATAGGIO DEL GRAFICO IN ALTA RISOLUZIONE
ggsave("immagini progetto stromboli/grafico_barre_confronto.png", plot = grafico_copertura, width = 10, height = 6, dpi = 300)
```

**[INSERISCI QUI: `grafico_barre_confronto.png`]**

Infine, per confrontare in modo più diretto la distribuzione dei valori di NDVI sulla terraferma nelle tre date, è stato prodotto un ridgeline plot. Un primo tentativo, condotto sull'intero stack (comprensivo dei pixel di mare), ha prodotto distribuzioni eccessivamente appuntite a causa della grande quantità di pixel d'acqua concentrati intorno allo stesso valore di NDVI:

```r
# Creazione dello stack dei layer NDVI e assegnazione dei relativi nomi
ndvi_stack <- c(ndvi_giu_19, ndvi_ago_19, ndvi_giu_20)
names(ndvi_stack) <- c("NDVI_Giu19_Pre", "NDVI_Ago19_Post", "NDVI_Giu20_Recupero")

# Generazione del ridgeline plot per il confronto delle distribuzioni c
im.ridgeline(ndvi_stack, scale=1, palette="mako")    # escono delle curve molto appuntite a causa della presenza di molti pixel d'H2O
```

Mascherando lo stack per escludere i pixel di mare (NDWI > 0), le distribuzioni risultano molto più leggibili e interpretabili:

```r
# PRODUZIONE DI UN RIDGELINE PLOT
# (nota: ho aggiunto il cancelletto iniziale mancante in questa riga di intestazione, presumibilmente perso in fase di copia-incolla, per mantenerla un commento R valido)

# Mascheriamo lo stack escludendo i pixel di mare (NDWI > 0) per ripulire le distribuzioni
ndvi_stack_isola <- ndvi_stack
ndvi_stack_isola[ndwi_giu19 > 0] <- NA

# Generazione del ridgeline plot pulito sulla sola terraferma
png("immagini progetto stromboli/grafico_ridgeline_ndvi.png", width = 10, height = 7, units = "in", res = 300)
im.ridgeline(ndvi_stack_isola, scale=1, palette="inferno")
dev.off()
```

**[INSERISCI QUI: `grafico_ridgeline_ndvi.png`]**

*Ci si attende che la distribuzione di agosto 2019 sia spostata verso valori di NDVI più bassi rispetto a giugno 2019, e che quella di giugno 2020 si collochi in una posizione intermedia, coerentemente con un recupero solo parziale.* **Completa qui con il commento al ridgeline plot:** ______________________________

## Conclusioni

L'analisi condotta sull'isola di Stromboli mostra un impatto netto del parossismo del 3 luglio 2019 e dei conseguenti incendi sulla copertura vegetale dell'isola: la percentuale di superficie classificata come vegetazione (NDVI > 0.27) è crollata dal 35,79% di giugno 2019 all'8,07% di agosto 2019, per poi risalire parzialmente al 25,18% a giugno 2020. Il quadro complessivo — una perdita di vegetazione severa e concentrata nell'immediato post-evento, seguita da un recupero apprezzabile ma non ancora completo a un anno di distanza — è coerente, dal punto di vista qualitativo, con quanto documentato in letteratura sugli incendi indotti dall'attività vulcanica a Stromboli nell'estate 2019, che hanno interessato porzioni significative dell'isola, in particolare nei settori occidentale e sud-occidentale, e per i quali sono comunque emerse indicazioni di una certa resilienza della vegetazione locale (Iacono et al., 2025).

Lo studio presenta alcuni limiti che è opportuno esplicitare. In primo luogo, ciascuna data è rappresentata da una singola acquisizione Sentinel-2 e non da un composito su più immagini: il dato è quindi potenzialmente sensibile a residui di foschia o a condizioni di illuminazione non perfettamente comparabili tra le scene. In secondo luogo, la soglia di NDVI utilizzata per separare vegetazione e suolo nudo (0.27) è stata scelta empiricamente, senza un confronto diretto con dati di verità a terra o con immagini a più alta risoluzione, a differenza di quanto fatto in letteratura con l'uso di rilievi drone o soglie validate su altri indici come il dNBR. Infine, l'analisi qui condotta si concentra sulla sola dicotomia vegetazione/non vegetazione, senza distinguere gradi diversi di severità del danno — distinzione che l'NBR permetterebbe in linea di principio di approfondire ulteriormente.

Come indicato in apertura, un possibile sviluppo naturale di questo lavoro è l'estensione della serie temporale all'anno successivo (2021), per verificare se il recupero osservato tra agosto 2019 e giugno 2020 sia proseguito, si sia stabilizzato, o abbia subito battute d'arresto nel medio termine — offrendo così un quadro più completo della traiettoria di recupero della vegetazione di Stromboli dopo il parossismo del 2019.

*(Se vuoi aggiungere una tua riflessione personale conclusiva, questo è lo spazio: ______________________________)*

## Riferimenti bibliografici

Iacono, F., Bisson, M., Spinetti, C., et al. (2025). Wildfires Induced by Volcanic Activity at Stromboli Island during the 2019 Summer through Satellite and Drone Data. *Remote Sensing in Earth Systems Sciences*, 8(2), 733–752. https://doi.org/10.1007/s41976-025-00215-6
