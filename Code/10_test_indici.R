# ==============================================================================
# SCRIPT DI PROVA PER IL TEST DI INDICI DI BRUCIATURA SULLA SOLA TERRAFERMA
# INDICI: BAI, B4/B3, VI6T INDEX
# Palette: mako per i temporali, turbo per le differenze (Delta)
# ==============================================================================

library(terra)
library(viridis)

# 1. CARICAMENTO DELLA BANDA TERMICA/CIRRUS (B10) PER IL CALCOLO DEL VI6T
# Importiamo le bande grezze a 20m/60m per estrarre la componente T
b10_giu19_raw <- rast("S2A_MSIL2A_20190607T095031_N0500_R079_T33SWC_20221219T154232.SAFE/GRANULE/L2A_T33SWC_A020668_20190607T095825/IMG_DATA/R60m/T33SWC_20190607T095031_B10_60m.jp2")
b10_ago19_raw <- rast("S2B_MSIL2A_20190811T095039_N0500_R079_T33SWC_20230505T051258.SAFE/GRANULE/L2A_T33SWC_A012689_20190811T095702/IMG_DATA/R60m/T33SWC_20190811T095039_B10_60m.jp2")
b10_giu20_raw <- rast("S2B_MSIL2A_20200626T095029_N0500_R079_T33SWD_20231109T220700.SAFE/GRANULE/L2A_T33SWD_A017265_20200626T095032/IMG_DATA/R60m/T33SWD_20200626T095029_B10_60m.jp2")

# Ritaglio ed allineamento geometrico sulla griglia ottica a 10m (usando b2_giu19_crop come riferimento)
b10_giu19_crop <- resample(crop(b10_giu19_raw, estensione_stromboli), b2_giu19_crop, method="bilinear")
b10_ago19_crop <- resample(crop(b10_ago19_raw, estensione_stromboli), b2_ago19_crop, method="bilinear")
b10_giu20_crop <- resample(crop(b10_giu20_raw, estensione_stromboli), b2_giu20_crop, method="bilinear")

# 2. APPLICAZIONE PREVENTIVA DELLA MASCHERA NDWI SULLA TERRAFERMA
# Assegniamo NA al mare per isolare le dinamiche dell isola ed evitare appiattimenti di colore
str_giu19_isola <- str_giu_19
str_giu19_isola[ndwi_giu19 > 0] <- NA

str_ago19_isola <- str_ago_19
str_ago19_isola[ndwi_ago19 > 0] <- NA

str_giu20_isola <- str_giu_20
str_giu20_isola[ndwi_giu20 > 0] <- NA

# Configurazione bande isolate per comodità di calcolo
red_giu19 <- str_giu19_isola[["B4"]]; nir_giu19 <- str_giu19_isola[["B8"]]; green_giu19 <- str_giu19_isola[["B3"]]
red_ago19 <- str_ago19_isola[["B4"]]; nir_ago19 <- str_ago19_isola[["B8"]]; green_ago19 <- str_ago_19_isola[["B3"]]
red_giu20 <- str_giu20_isola[["B4"]]; nir_giu20 <- str_giu20_isola[["B8"]]; green_giu20 <- str_giu20_isola[["B3"]]


# ==============================================================================
# ELABORAZIONE 1: BURN AREA INDEX (BAI)
# ==============================================================================

# Calcolo dell indice di distanza spettrale dal punto fisso del carbone puro
bai_giu19 <- 1 / ((0.1 - red_giu19)^2 + (0.06 - nir_giu19)^2)
bai_ago19 <- 1 / ((0.1 - red_ago19)^2 + (0.06 - nir_ago19)^2)
bai_giu20 <- 1 / ((0.1 - red_giu20)^2 + (0.06 - nir_giu20)^2)

# Calcolo del trend di impatto immediato (Post - Pre)
dbai_19 <- bai_ago19 - bai_giu19

# Plot Multitemporale Continuo BAI (Pannello pulito 1x3 senza sovrapposizioni)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(bai_giu19, col = mako(100), main = "BAI Giugno 2019 (Pre)")
plot(bai_ago19, col = mako(100), main = "BAI Agosto 2019 (Post)")
plot(bai_giu20, col = mako(100), main = "BAI Giugno 2020 (Recupero)")

# Plot Differenziale Immediato Delta BAI (Pannello singolo o 1x1)
par(mfrow = c(1, 1), mar = c(4, 4, 4, 5))
plot(dbai_19, col = turbo(100), main = "Delta BAI - Variazione Carbone Focale")


# ==============================================================================
# ELABORAZIONE 2: RAPPORTO SEMPLICE ROSSO / VERDE (B4 / B3)
# ==============================================================================

# Rapporto spettrale per evidenziare la perdita di clorofilla e l arrossamento del suolo
r_b4b3_giu19 <- red_giu19 / green_giu19
r_b4b3_ago19 <- red_ago19 / green_ago19
r_b4b3_giu20 <- red_giu20 / green_giu20

# Delta rapporto per evidenziare le anomalie di stress da bruciatura
dr_b4b3_19 <- r_b4b3_ago19 - r_b4b3_giu19

# Plot Multitemporale Continuo B4/B3 (Struttura 1x3 ordinata)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(r_b4b3_giu19, col = mako(100), main = "B4/B3 Giugno 2019 (Pre)")
plot(r_b4b3_ago19, col = mako(100), main = "B4/B3 Agosto 2019 (Post)")
plot(r_b4b3_giu20, col = mako(100), main = "B4/B3 Giugno 2020 (Recupero)")

# Plot Differenziale Delta B4/B3
par(mfrow = c(1, 1), mar = c(4, 4, 4, 5))
plot(dr_b4b3_19, col = turbo(100), main = "Delta B4/B3 - Anomalie di Arrossamento")


# ==============================================================================
# ELABORAZIONE 3: VI6T INDEX (INDICE COMBINATO NIR - TERMICO)
# ==============================================================================

# Formula matematica rigida con riscalamento spettrale costante della banda T
vi6t_giu19 <- (nir_giu19 - (b10_giu19_crop / 10000)) / (nir_giu19 + (b10_giu19_crop / 10000))
vi6t_ago19 <- (nir_ago19 - (b10_ago19_crop / 10000)) / (nir_ago19 + (b10_ago19_crop / 10000))
vi6t_giu20 <- (nir_giu20 - (b10_giu20_crop / 10000)) / (nir_giu20 + (b10_giu20_crop / 10000))

# Delta VI6T per mappare lo slittamento della risposta termica indotta dal fuoco
dvi6t_19 <- vi6t_giu19 - vi6t_ago19

# Plot Multitemporale Continuo VI6T Index (Struttura 1x3 separata)
par(mfrow = c(1, 3), mar = c(4, 3, 4, 5))
plot(vi6t_giu19, col = mako(100), main = "VI6T Giugno 2019 (Pre)")
plot(vi6t_ago19, col = mako(100), main = "VI6T Agosto 2019 (Post)")
plot(vi6t_giu20, col = mako(100), main = "VI6T Giugno 2020 (Recupero)")

# Plot Differenziale Delta VI6T Index
par(mfrow = c(1, 1), mar = c(4, 4, 4, 5))
plot(dvi6t_19, col = turbo(100), main = "Delta VI6T Index - Severità Termo-Ottica")





# ASSESSMENT GEOLOGICO E PETROGRAFICO: RAPPORTI TRA BANDE (BAND RATIOS)

# 2. PLOT MINERALI FERROSI 
ferrous_giu_19 <- str_giu_19[["B12"]] / str_giu_19[["B8"]]
ferrous_ago_19 <- str_ago_19[["B12"]] / str_ago_19[["B8"]]

limiti_ferrous <- quantiles(c(ferrous_giu_19, ferrous_ago_19), probs = c(0.005, 0.995))

png("immagini progetto stromboli/geologia_ferrous_minerals_confronto.png", width = 10, height = 5, units = "in", res = 300)
par(mfrow = c(1, 2), mar = c(4, 3, 4, 5))
plot(ferrous_giu_19, col = mako(100), range = limiti_ferrous, main = "Minerali Ferrosi - Giugno 2019 (Pre)")
plot(ferrous_ago_19, col = mako(100), range = limiti_ferrous, main = "Minerali Ferrosi - Agosto 2019 (Post)")
dev.off()
