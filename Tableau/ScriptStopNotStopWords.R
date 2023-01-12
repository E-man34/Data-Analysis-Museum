library(rtweet)
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(tm)
library(tidytext)
library(dplyr)
library(ggplot2)
library(wordcloud)
library(stringr)
library(openxlsx)
library(tuber)
library(syuzhet)
library(topicmodels)
library(tibble)
library(reshape2)
library(wordcloud2)
library(tidyr)
library(readxl)


Auto <- read_excel("TesiMaster/Dati/Museo Automobile/Export/Auto.xlsx")


#--------------------- TOKENIZZAZIONE + MULTIWORDS + DATA CLEANING --------------------- 

Auto <- Auto %>% #comando pipe in cui il risultato di questa riga è l'input della riga dopo
  select(testo) %>%
  unnest_tokens(word,testo) #%>% #dividiamo la colonna "comment"  nelle singole parole
  #anti_join(stopwords) #da cui si sottraggono le stopwords



# creazione colonna con valore di default

Auto$isStop <- "NO-STOP"

# ciclo for per controllare il match tra parola dataset e parola nelle stopwords
for(i in 1:nrow(Auto)){
  Auto$isStop[Auto$word == stopwords$word[i]] <- "STOP"
}

write.xlsx(Auto, "TableAuto3.xlsx")
