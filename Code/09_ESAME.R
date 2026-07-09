# PROGETTO DI TELERILEVAMENTO IN R - ANDREA CERASOLI

# ANALISI TEMPORALE PRE E POST ERUZIONE SULL'ISOLA DI STROMBOLI

# Ho scaricato immagini Sentinel_2 di Stromboli dal browser open source dell'ESA Copernicus
# Ho preferito scaricare le immagini da Copernicus invece che da GEE per avere maggiore controllo e scelta sull'immagine 
# da scaricare: trattandosi di un vulcano, le condizioni di visibilità e copertura nuvolosa, spesso nelle fasi successive a un'eruzione
# sono spesso inadatte a svolgere un analisi temporale

# Devo ritagliare le immagini e creare uno stack manualmente

library(terra)      # Per lavorare con raster e immagini satellitari
library(imageRy)    # Funzioni di visualizzazione rapide
library(viridis)    # Palette di colori
library(ggplot2)    # Pacchetto per la creazione di grafici
library(reshape2)   # Riorganizzazioni dei dati tabellari

# IMPOSTAZIONE WORKSPACE E CARICAMENTO BANDE A 10 METRI

# Configurazione della cartella principale di lavoro (Working Directory)
setwd("C:/Users/User/Desktop/telerilevamento in R/progetto esame Stromboli")

# GIUGNO - PRE
b2_giugno <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B02_10m.jp2") # uso la funzione rast per caricare il percorso
b3_giugno <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B03_10m.jp2")
b4_giugno <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B04_10m.jp2")
b8_giugno <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R10m/T33SWC_20190607T095031_B08_10m.jp2")

# AGOSTO - POST
b2_agosto <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B02_10m.jp2")
b3_agosto <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B03_10m.jp2")
b4_agosto <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B04_10m.jp2")
b8_agosto <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R10m/T33SWC_20190811T095039_B08_10m.jp2")

# Confrontiamo giugno e agosto per essere sicuri che si le due immagini siano proiettate nello stesso
# sistema di riferimento e che si sovrappongano alla perfezione

crs(b2_giugno)
# "PROJCRS[\"WGS 84 / UTM zone 33N\",\n
crs(b2_agosto) 
# "PROJCRS[\"WGS 84 / UTM zone 33N\",\n

ext(b2_giugno)
# SpatExtent : 499980, 609780, 4190220, 4300020 (xmin, xmax, ymin, ymax)
ext(b2_agosto)
# SpatExtent : 499980, 609780, 4190220, 4300020 (xmin, xmax, ymin, ymax)

# DEFINIZIONE ESTENSIONE E RITAGLIO (CROP)

# Ordine richiesto dalla funzione ext(): xmin, xmax, ymin, ymax
estensione_stromboli <- ext(515715, 521500, 4291265, 4296385)

# RITAGLIO (CROP) DI TUTTE LE BANDE DI GIUGNO

b2_giu_crop <- crop(b2_giugno, estensione_stromboli)
b3_giu_crop <- crop(b3_giugno, estensione_stromboli)
b4_giu_crop <- crop(b4_giugno, estensione_stromboli)
b8_giu_crop <- crop(b8_giugno, estensione_stromboli)

# RITAGLIO (CROP) DI TUTTE LE BANDE DI AGOSTO

b2_ago_crop <- crop(b2_agosto, estensione_stromboli)
b3_ago_crop <- crop(b3_agosto, estensione_stromboli)
b4_ago_crop <- crop(b4_agosto, estensione_stromboli)
b8_ago_crop <- crop(b8_agosto, estensione_stromboli)

# CREAZIONE DEGLI STACK MULTI-BANDA E VISUALIZZAZIONE RGB

# Uniamo le bande nell'ordine classico: B2 (1), B3 (2), B4 (3), B8 (4)
str_giu <- c(b2_giu_crop, b3_giu_crop, b4_giu_crop, b8_giu_crop)
str_ago <- c(b2_ago_crop, b3_ago_crop, b4_ago_crop, b8_ago_crop)

# Controllo veloce della struttura dello stack in console
str_giu
str_ago

# VISUALIZZAZIONE IN COLORI REALI (True Color - RGB 3,2,1)
par(mfrow=c(1,2))
plotRGB(str_giu, r=3, g=2, b=1, stretch="lin", main="Stromboli Giugno - Colori Reali")
plotRGB(str_ago, r=3, g=2, b=1, stretch="lin", main="Stromboli Agosto - Colori Reali")














