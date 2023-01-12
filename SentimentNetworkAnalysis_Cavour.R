library(rtweet)
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(tm)
library(tidytext)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(wordcloud)
library(stringr)
library(openxlsx)
library(syuzhet)
library(topicmodels)
library(tibble)
library(reshape2)
library(wordcloud2)
library(tidyr)
library(readxl)
library(igraph)
library(ggraph)


Cavour <- read_excel("Export/Cavour.xlsx")

#------------------------------- SENTIMENT ANALYSIS -------------------------------


Cavour <- Cavour %>% #comando pipe in cui il risultato di questa riga è l'input della riga dopo
  select(testo) %>%
  unnest_tokens(word, testo) #dividiamo la colonna "comment"  nelle singole parole

sentiment <- as.character(Cavour$word) #convertire colonna commenti in un vettore di char

etichette <- get_nrc_sentiment(sentiment, language = "italian") #calcolare i dizionari per le diverse emozioni

#unione calcolo sentiment con il dataset originale
dataset_sentiment <- cbind(Cavour$word, etichette)

#creazione etichette colonne 
c <- c("text", "Rabbia", "Aspettativa", "Disgusto", "Paura", "Gioia", "Tristezza", "Sorpresa", "Fiducia", "Negativo", "Positivo")
names(dataset_sentiment) <- c

# primo export per avere tutte le colonne delle emozioni
write.xlsx(dataset_sentiment,"SentimentAnalysis_SingleWord_Cavour.xlsx")


# calcolo sentiment recensione dominante


dataset_sentiment$SENTIMENT <- colnames(dataset_sentiment)[apply(dataset_sentiment, 1, which.max)]


# controllo per eliminare "finta" etichetta "Rabbia" come sentiment dominante
for(i in 1:nrow(dataset_sentiment)){
  if(dataset_sentiment$SENTIMENT[i] == "Rabbia" & dataset_sentiment$Rabbia[i] == 0) {
    dataset_sentiment$SENTIMENT[i] <- "NA"
  }
}


# secondo export per recensioni aggregate
write.xlsx(dataset_sentiment,"SentimentDominante.xlsx")

#get_nrc_sentiment("protesta", language = "italian") #ricerca punteggi per parola "protesta"

#GRAFICO sentiment analysis
barplot(colSums(etichette),
        las = 2,
        col=brewer.pal(8, "Set2"),
        ylab = "Valore",
        main = "Memoriale Cavour - Sentiment Analysis")








#-------------------------------  RELAZIONI TRA PAROLE ------------------------------- 

Cavour_lemm <- read_excel("/Users/Emanuele/Desktop/TesiMaster/Dati/Memoriale Cavour/Export/Cavour_lemm.xlsx")


#creazione dataset di partenza
a_corp <- as.character(Cavour_lemm$testo) #trasformare colonna del testo in vettore carattere

token_dfm <- tokens(a_corp, remove_punct=TRUE) # trasformazione prima in token e poi in dfm
tweet_dfm <- dfm(token_dfm, remove_punct=TRUE) #creare matrice documenti (riga) - termini dei testi (colonna) per vedere quale termine ricorre in quale testo + rimozione punteggiatura

tag_dfm <- dfm_select(tweet_dfm, pattern = ("*")) #selezione su tweet_dfm cercando il pattern # seguito da una parole per mentenere solo i termini che corrispondono ad un hashtag
toptag <- names(topfeatures(tag_dfm, 100)) #mantiene solo le top 50 parole che ricorrono maggiormente
head(toptag)

tag_fcm <- fcm(tag_dfm) #creare matrice di co-occorrenza
head(tag_fcm)

toptag_fcm <- fcm_select(tag_fcm, pattern = toptag) #selezionare top tag individuati in oggetto toptag_fcm

#creazione grafico network analysis
textplot_network(toptag_fcm,  #matrice di co-occorrenza
                 min_freq = 1, #soglia minima di frequenza
                 edge_alpha = 1.2, #opacità legame
                 edge_size = 1, #spessore del legame
                 vertex_size = 1.5, #grandezza dei vertici
                 vertex_labelsize = 3)



assoc<-as.data.frame(findAssocs(dat.TDM, "museo", corlimit = 0.1))
assoc<-data.frame(termini= rownames(assoc),corlimit=c(assoc[,1]))

write.xlsx(assoc, "Dat.xlsx")

# RICERCA PAROLE FRASI

cerco_auto <- dplyr::filter(Auto_clean, grepl('[Aa]uto', testo)) 
cerco_auto <- select(cerco_auto, "testo")



a <- arrow(angle = 30, length = unit(0.1, "inches"), ends = "last", type = "open")

Dat %>% 
  filter(Frequenza > 400) %>% 
  graph_from_data_frame() %>% 
  ggraph(layout = "fr") + 
  geom_edge_link(aes(color = Frequenza, width = Frequenza), arrow = a) + 
  geom_node_point() + 
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)

# la distanza tra parole non ha nessun significato ma è random