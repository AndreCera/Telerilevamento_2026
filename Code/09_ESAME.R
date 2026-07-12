# PROGETTO DI TELERILEVAMENTO IN R - ANDREA CERASOLI

# ANALISI TEMPORALE PRE E POST ERUZIONE SULL'ISOLA DI STROMBOLI

# Ho scaricato immagini Sentinel_2 di Stromboli dal browser open source dell'ESA Copernicus
# Ho preferito scaricare le immagini da Copernicus invece che da GEE per avere maggiore controllo e scelta sull'immagine 
# da scaricare: trattandosi di un vulcano, le condizioni di visibilità e copertura nuvolosa, spesso nelle fases successive a un'eruzione
# sono spesso inadatte a svolgere un analisi temporale

# Devo ritagliare le immagini e creare uno stack manualmente

library(terra)      # Per lavorare con raster e immagini satellitari
library(imageRy)    # Funzioni di visualizzazione rapide
library(viridis)    # Palette di colori
library(ggplot2)    # Pacchetto per la creazione di grafici
library(reshape2)   # Riorganizzazioni dei dati tabellari

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

# plot delle bande 
plot(str_giu_19, col=plasma(100))
plot(str_ago_19, col=plasma(100))
plot(str_giu_20, col=plasma(100))

# VISUALIZZAZIONE IN COLORI REALI (True Color - RGB 3,2,1)
par(mfrow=c(1,3))
plotRGB(str_giu_19, r=3, g=2, b=1, stretch="lin", main="Giugno 2019 (Pre)")
plotRGB(str_ago_19, r=3, g=2, b=1, stretch="lin", main="Agosto 2019 (Post)")
plotRGB(str_giu_20, r=3, g=2, b=1, stretch="lin", main="Giugno 2020 (Recupero)")

# VISUALIZZAZIONE IN FALSI COLORI (RGB 4,3,2)
plotRGB(str_giu_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2019")
plotRGB(str_ago_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Agosto 2019")
plotRGB(str_giu_20, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2020")


nota l'aggiunta# plot delle bande 
plot(str_giu_19, col=plasma(100))
plot(str_ago_19, col=plasma(100))
plot(str_giu_20, col=plasma(100))

ti plotta tutte le bande seguendo la colorscale pacchetto viridis giusto?
da domani si riparte da qui# PROGETTO DI TELERILEVAMENTO IN R - ANDREA CERASOLI

# ANALISI TEMPORALE PRE E POST ERUZIONE SULL'ISOLA DI STROMBOLI

# Ho scaricato immagini Sentinel_2 di Stromboli dal browser open source dell'ESA Copernicus
# Ho preferito scaricare le immagini da Copernicus invece che da GEE per avere maggiore controllo e scelta sull'immagine 
# da scaricare: trattandosi di un vulcano, le condizioni di visibilità e copertura nuvolosa, spesso nelle fases successive a un'eruzione
# sono spesso inadatte a svolgere un analisi temporale

# Devo ritagliare le immagini e creare uno stack manualmente

library(terra)      # Per lavorare con raster e immagini satellitari
library(imageRy)    # Funzioni di visualizzazione rapide
library(viridis)    # Palette di colori
library(ggplot2)    # Pacchetto per la creazione di grafici
library(reshape2)   # Riorganizzazioni dei dati tabellari

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

# ViSUALIZZAZIONE E ESPORTAZIONE DELLE BANDE
png("immagini progetto stromboli/bande_str_giu_19.png", width = 12, height = 8, units = "in", res = 300)
plot(str_giu_19, col=plasma(100))
dev.off()

png("immagini progetto stromboli/bande_separate_giu19.png", width = 12, height = 8, units = "in", res = 300)
par(mfrow = c(2, 3), mar = c(4, 3, 4, 5))
plot(str_giu_19[["B2"]], col = plasma(100), main = "Blu (B2)")
plot(str_giu_19[["B3"]], col = plasma(100), main = "Verde (B3)")
plot(str_giu_19[["B4"]], col = plasma(100), main = "Rosso (B4)")
plot(str_giu_19[["B8"]], col = plasma(100), main = "NIR (B8)")
plot(str_giu_19[["B12"]], col = plasma(100), main = "SWIR (B12)")
dev.off()

# AGO - 19
png("immagini progetto stromboli/bande_str_ago_19.png", width = 12, height = 8, units = "in", res = 300)
plot(str_ago_19, col=plasma(100))
dev.off()

png("immagini progetto stromboli/bande_separate_ago19.png", width = 12, height = 8, units = "in", res = 300)
par(mfrow = c(2, 3), mar = c(4, 3, 4, 5))
plot(str_ago_19[["B2"]], col = plasma(100), main = "Blu (B2)")
plot(str_ago_19[["B3"]], col = plasma(100), main = "Verde (B3)")
plot(str_ago_19[["B4"]], col = plasma(100), main = "Rosso (B4)")
plot(str_ago_19[["B8"]], col = plasma(100), main = "NIR (B8)")
plot(str_ago_19[["B12"]], col = plasma(100), main = "SWIR (B12)")
dev.off()

# GIU - 20
png("immagini progetto stromboli/bande_str_giu_20.png", width = 12, height = 8, units = "in", res = 300)
plot(str_giu_20, col=plasma(100))
dev.off()

png("immagini progetto stromboli/bande_separate_giu20.png", width = 12, height = 8, units = "in", res = 300)
par(mfrow = c(2, 3), mar = c(4, 3, 4, 5))
plot(str_giu_20[["B2"]], col = plasma(100), main = "Blu (B2)")
plot(str_giu_20[["B3"]], col = plasma(100), main = "Verde (B3)")
plot(str_giu_20[["B4"]], col = plasma(100), main = "Rosso (B4)")
plot(str_giu_20[["B8"]], col = plasma(100), main = "NIR (B8)")
plot(str_giu_20[["B12"]], col = plasma(100), main = "SWIR (B12)")
dev.off()

# VISUALIZZAZIONE IN COLORI REALI (True Color - RGB 3,2,1)
png("immagini progetto stromboli/true_color_confronto.png")
par(mfrow = c(1, 3), mar = c(3, 3, 4, 2))  # rendo l'immagine multiframe e sistemo i margini per ottimizzare la visualizzazione
plotRGB(str_giu_19, r=3, g=2, b=1, stretch="lin", main="Giugno 2019 (Pre)")
plotRGB(str_ago_19, r=3, g=2, b=1, stretch="lin", main="Agosto 2019 (Post)")
plotRGB(str_giu_20, r=3, g=2, b=1, stretch="lin", main="Giugno 2020 (Recupero)")
dev.off()

# VISUALIZZAZIONE E ESPORTAZIONE IN FALSI COLORI (RGB 4,3,2)
png("immagini progetto stromboli/false_color_confronto.png")
par(mfrow = c(1, 3), mar = c(3, 3, 4, 2))
plotRGB(str_giu_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2019")
plotRGB(str_ago_19, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Agosto 2019")
plotRGB(str_giu_20, r=4, g=3, b=2, stretch="lin", main="Falsi Colori - Giugno 2020")
dev.off() # Chiudere il pannello di Visualizzazione delle immagini e ristabilire il formato dei grafici a quello di default

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

# VISUALIZZAZIONE E ESPORTAZIONE DVI

# Grafico 1: Impatto Immediato DVI (2019)
png("immagini progetto stromboli/dvi_impatto_2019.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(dvi_giu_19, col = cividis(100), main = "DVI Giugno 2019 (Pre)")
plot(dvi_ago_19, col = cividis(100), main = "DVI Agosto 2019 (Post)")
plot(ddvi_19, col = turbo(100), main = "Delta DVI (Impatto 2019)")
dev.off()

# Grafico 2: Recupero DVI (2019 vs 2020)
png("immagini progetto stromboli/dvi_recupero_2020.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(dvi_ago_19, col = cividis(100), main = "DVI Agosto 2019 (Post)")
plot(dvi_giu_20, col = cividis(100), main = "DVI Giugno 2020 (Recupero)")
plot(ddvi_20, col = turbo(100), main = "Delta DVI (Recupero 19-20)")
dev.off()

# Grafico 3: Bilancio Netto Annuale DVI (Giugno vs Giugno)
png("immagini progetto stromboli/dvi_bilancio_annuale.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(dvi_giu_19, col = cividis(100), main = "DVI Giugno 2019 (Pre)")
plot(dvi_giu_20, col = cividis(100), main = "DVI Giugno 2020 (Recupero)")
plot(ddvi_netto, col = turbo(100), main = "Delta DVI Netto (Annuale)")
dev.off()

# INDICE NDVI (Normalized Difference Vegetation Index)

# Calcolo indici
ndvi_giu_19 <- (str_giu_19[["B8"]] - str_giu_19[["B4"]]) / (str_giu_19[["B8"]] + str_giu_19[["B4"]])
ndvi_ago_19 <- (str_ago_19[["B8"]] - str_ago_19[["B4"]]) / (str_ago_19[["B8"]] + str_ago_19[["B4"]])
ndvi_giu_20 <- (str_giu_20[["B8"]] - str_giu_20[["B4"]]) / (str_giu_20[["B8"]] + str_giu_20[["B4"]])

# Calcolo differenze
dndvi_19    <- ndvi_giu_19 - ndvi_ago_19  # Impatto immediato dell'eruzione[cite: 1]
dndvi_20    <- ndvi_ago_19 - ndvi_giu_20  # Recupero post-evento[cite: 1]
dndvi_netto <- ndvi_giu_19 - ndvi_giu_20  # Bilancio del vigore netto a un anno

# VISUALIZZAZIONE E ESPORTAZIONE NDVI

# Grafico 1: Impatto Immediato NDVI (2019)
png("immagini progetto stromboli/ndvi_impatto_2019.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(ndvi_giu_19, col = mako(100), main = "NDVI Giugno 2019 (Pre)")
plot(ndvi_ago_19, col = mako(100), main = "NDVI Agosto 2019 (Post)")
plot(dndvi_19, col = turbo(100), main = "Delta NDVI (Impatto 2019)")
dev.off()

# Grafico 2: Recupero NDVI (2019 vs 2020)
png("immagini progetto stromboli/ndvi_recupero_2020.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(ndvi_ago_19, col = mako(100), main = "NDVI Agosto 2019 (Post)")
plot(ndvi_giu_20, col = mako(100), main = "NDVI Giugno 2020 (Recupero)")
plot(dndvi_20, col = turbo(100), main = "Delta NDVI (Recupero 19-20)")
dev.off()

# Grafico 3: Bilancio Netto Annuale NDVI (Giugno vs Giugno)
png("immagini progetto stromboli/ndvi_bilancio_annuale.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(ndvi_giu_19, col = mako(100), main = "NDVI Giugno 2019 (Pre)")
plot(ndvi_giu_20, col = mako(100), main = "NDVI Giugno 2020 (Recupero)")
plot(dndvi_netto, col = turbo(100), main = "Delta NDVI Netto (Annuale)")
dev.off()

# INDICE NBR (Normalized Burn Ratio)

# Calcolo indici
nbr_giu_19 <- (str_giu_19[["B8"]] - str_giu_19[["B12"]]) / (str_giu_19[["B8"]] + str_giu_19[["B12"]])
nbr_ago_19 <- (str_ago_19[["B8"]] - str_ago_19[["B12"]]) / (str_ago_19[["B8"]] + str_ago_19[["B12"]])
nbr_giu_20 <- (str_giu_20[["B8"]] - str_giu_20[["B12"]]) / (str_giu_20[["B8"]] + str_giu_20[["B12"]])

# Calcolo differenze
dnbr_19    <- nbr_giu_19 - nbr_ago_19  # Severità del danno immediata
dnbr_20    <- nbr_ago_19 - nbr_giu_20  # Attenuazione del danno
dnbr_netto <- nbr_giu_19 - nbr_giu_20  # Severità del danno permanente a un anno

# VISUALIZZAZIONE E ESPORTAZIONE NBR

# Grafico 1: Impatto Immediato NBR (2019)
png("immagini progetto stromboli/nbr_impatto_2019.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(nbr_giu_19, col = rocket(100), main = "NBR Giugno 2019 (Pre)")
plot(nbr_ago_19, col = rocket(100), main = "NBR Agosto 2019 (Post)")
plot(dnbr_19, col = turbo(100), main = "Delta NBR (dNBR 2019)")
dev.off()

# Grafico 2: Recupero NBR (Agosto 2019 vs Giugno 2020)
png("immagini progetto stromboli/nbr_recupero_2020.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(nbr_ago_19, col = rocket(100), main = "NBR Agosto 2019 (Post)")
plot(nbr_giu_20, col = rocket(100), main = "NBR Giugno 2020 (Recupero)")
plot(dnbr_20, col = turbo(100), main = "Delta NBR (dNBR 19-20)")
dev.off()

# Grafico 3: Bilancio Netto Annuale NBR (Giugno 19 vs Giugno 20)
png("immagini progetto stromboli/nbr_bilancio_annuale.png", width = 14, height = 5, units = "in", res = 300)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(nbr_giu_19, col = rocket(100), main = "NBR Giugno 2019 (Pre)")
plot(nbr_giu_20, col = rocket(100), main = "NBR Giugno 2020 (Recupero)")
plot(dnbr_netto, col = turbo(100), main = "Delta NBR Netto (Annuale)")
dev.off()



