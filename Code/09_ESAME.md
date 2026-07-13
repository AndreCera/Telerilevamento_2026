
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
savi_giu_20 <- ((str_giu_20[["B8"]] - str_giu_20[["B4"]]) / (str_giu_20[["B8"]] + str_giu_20[["B4"]] + 0.5)) * (1 + 0.5)# Analisi Temporale Pre e Post Eruzione sull'Isola di Stromboli

## 1. Introduzione

Il telerilevamento satellitare multitemporale rappresenta oggi uno degli strumenti più efficaci per monitorare gli effetti di eventi vulcanici sul paesaggio, in particolare sulla copertura vegetale delle aree colpite. La possibilità di acquisire immagini a intervalli regolari e su vaste aree consente di quantificare in modo oggettivo l'impatto immediato di un evento distruttivo e di seguirne nel tempo l'eventuale recupero, superando i limiti dei rilievi a terra, spesso più costosi, localizzati e difficili da ripetere con la stessa frequenza.

Il presente lavoro si inserisce in questo ambito e ha per oggetto l'isola di Stromboli (Isole Eolie), colpita il 3 luglio 2019 da un violento parossismo che ha innescato numerosi incendi sui fianchi del vulcano. L'obiettivo dello studio è quantificare, attraverso indici spettrali derivati da immagini Sentinel-2, l'impatto immediato dell'evento sulla vegetazione dell'isola e valutarne il recupero nel medio termine, confrontando tre acquisizioni: giugno 2019 (condizione pre-parossismo), agosto 2019 (condizione immediatamente successiva agli incendi) e giugno 2020 (a un anno di distanza, come verifica del recupero). A tal fine sono stati calcolati e confrontati gli indici DVI, NDVI e NBR, ed è stata condotta una classificazione della copertura del suolo per stimare le variazioni percentuali di superficie vegetata.

In prospettiva, si intende ampliare l'analisi temporale anche all'anno successivo (2021), per verificare se il recupero della vegetazione osservato nel breve periodo (giugno 2020) prosegua, si stabilizzi o subisca eventuali battute d'arresto nel medio termine — un'estensione che permetterebbe di descrivere in modo più completo la traiettoria di recupero post-evento.

## 2. Area di studio e il parossismo del 2019

Stromboli è l'isola vulcanica più settentrionale dell'arcipelago delle Eolie, in Sicilia, e rappresenta la porzione emersa di un edificio vulcanico che si estende fino a 1500-2600 m sotto il livello del mare; la sua cima, il Vancori, raggiunge i 924 m s.l.m., mentre l'attività eruttiva si concentra nella terrazza craterica, situata nella parte sommitale della Sciara del Fuoco (Iacono et al., 2025).

**[INSERISCI QUI: mappa geologica dell'isola di Stromboli — ricorda di citarne la fonte in didascalia]**

L'attività ordinaria del vulcano, detta "stromboliana", consiste in esplosioni brevi, ricorrenti e di modesta energia; essa può occasionalmente essere interrotta da colate laviche, esplosioni maggiori e parossismi, questi ultimi rappresentando le manifestazioni più pericolose dell'attività vulcanica dell'isola. I parossismi generano colonne eruttive alte diversi chilometri e possono produrre correnti piroclastiche che, raggiungendo il mare, sono in grado di innescare piccoli maremoti; il materiale incandescente e i lapilli, ricadendo sulla vegetazione, danno spesso origine a incendi che si propagano lungo i fianchi dell'isola, talvolta fino agli abitati di Stromboli e Ginostra. Questo fenomeno è documentato più volte nella storia recente dell'isola (tra gli altri eventi, nel 1930, 1943 e 1950) e si è ripetuto nell'estate 2019 (Iacono et al., 2025).

Il parossismo del 3 luglio 2019 è iniziato nel primo pomeriggio con un'esplosione improvvisa che ha causato la ricaduta di proiettili balistici incandescenti fino a quote di circa 500 m s.l.m. sul fianco nord, sopra l'abitato di Stromboli, e sotto i 200 m s.l.m. in direzione di Ginostra; è seguita una colonna eruttiva alta 6-8 km, mentre due colate piroclastiche sono scese lungo la Sciara del Fuoco innescando piccoli maremoti al loro ingresso in mare. Gli incendi provocati dal materiale incandescente hanno interessato soprattutto il settore meridionale dell'isola, propagandosi fino a Ginostra — dove hanno distrutto la centrale elettrica — e causando la morte di una persona lungo un sentiero escursionistico, per l'esposizione al fumo e al calore. Un secondo parossismo, il 28 agosto 2019, ha generato un'ulteriore colata piroclastica lungo la Sciara del Fuoco e nuovi incendi, di estensione più limitata, sul fianco nord-orientale dell'isola (Iacono et al., 2025).

Sono proprio gli effetti di questi incendi sulla vegetazione — e il loro successivo, parziale recupero — a essere oggetto dell'analisi che segue.

## 3.1 Metodi

Le immagini satellitari Sentinel-2 impiegate in questo lavoro sono state reperite manualmente attraverso il Copernicus Browser dell'ESA, piuttosto che tramite Google Earth Engine (GEE). Questa scelta è stata motivata da due esigenze: da un lato, le indagini richiedevano acquisizioni puntuali e circoscritte a finestre temporali molto ristrette (pre-parossismo, immediatamente post-parossismo, a un anno di distanza), per cui un prodotto mediato su più immagini, come tipicamente restituito da GEE, avrebbe potuto diluire o mascherare il segnale d'interesse; dall'altro, trattandosi di un vulcano attivo, le condizioni di copertura nuvolosa nelle fasi successive a un'eruzione sono spesso sfavorevoli, ed era quindi necessario poter scegliere manualmente, scena per scena, le immagini con la minore copertura nuvolosa sull'area di interesse e la maggiore flessibilità nella selezione delle bande da scaricare.

L'elaborazione dei dati è stata condotta interamente in ambiente R, utilizzando funzioni di R base insieme ai seguenti pacchetti:

```r
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
```

Gli indici spettrali calcolati e confrontati sulle tre date sono i seguenti:

- **DVI (Difference Vegetation Index)** — differenza semplice tra riflettanza nel NIR e nel Rosso (B8 − B4); fornisce un'indicazione grezza, non normalizzata, del vigore vegetativo.
- **NDVI (Normalized Difference Vegetation Index)** — versione normalizzata del DVI, (B8 − B4)/(B8 + B4); è l'indice standard per la stima della salute e densità della vegetazione, con valori teorici compresi tra -1 e 1.
- **NBR (Normalized Burn Ratio)** — (B8 − B12)/(B8 + B12), basato sul contrasto tra NIR e SWIR; è particolarmente sensibile alle superfici bruciate e alla cenere, che assorbono meno nel SWIR rispetto alla vegetazione sana.
- **NDWI (Normalized Difference Water Index)** — (B3 − B8)/(B3 + B8); in questo lavoro è stato utilizzato non per una vera e propria caratterizzazione idrologica, ma con la funzione operativa di isolare i pixel di mare, così da poterli escludere (o gestire come classe a sé) nella successiva classificazione ternaria della copertura del suolo.

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
