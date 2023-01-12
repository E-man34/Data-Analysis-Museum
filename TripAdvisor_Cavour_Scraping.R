library(RSelenium)
library(rvest)
library(tidyverse)
library(sys)
library(netstat)
library(openxlsx)


url <- "https://www.tripadvisor.com/Attraction_Review-g1820476-d4868285-Reviews-Castello_Cavour_Santena-Santena_Province_of_Turin_Piedmont.html"

# APERTURA BROWSER + SESSIONE 

rD <- rsDriver(browser="firefox", port = 4567L, verbose=F)
remDr <- rD[["client"]]
remDr$navigate(url) # dirgli di navigare nell'URL specificato

html <- remDr$getPageSource()[[1]]
html <- read_html(html)


# --------------------------------------------  SCRAPING PRIMA PAGINA  -------------------------------------------- 

recensioni<-data.frame() # creazione oggetto vuoto

reviews <- html %>% # Name a variable reviews and take a look at the html
  html_elements(".KxBGd .yCeTE") %>% # In particular, look at the class named .cPQsENeY
  html_text() %>% # Grab the text contained with this class
  as_tibble(reviews) # And save it as a tibble to reviews.

dates <- html %>%
  html_elements(".ncFvv.osNWb") %>%
  html_text() %>%
  str_remove_all("Scritta in data ") %>% # Remove unwanted strings
  as_tibble(dates)

title <- html %>%
  html_elements(".ukgoS .yCeTE") %>%
  html_text() %>% # Grab the text contained with this class
  as_tibble(title)

score <- html %>%
  html_elements("#tab-data-qa-reviews-0 .f.k+ div") %>%
  html_children() %>% # Look at the child of the named class
  html_attr("aria-label") %>% # Grab the name of the class of the child
  str_remove_all("Punteggio") %>% # Remove unwanted strings
  str_remove_all("su 5") %>%
  as_tibble(dates)

combined <- bind_cols(dates, title, reviews, score)
recensioni<-rbind(recensioni, bind_cols(dates, title, reviews, score))





#________________________________ SCRAPING SECONDA PAGINA IN POI ______________________________________


# CHUNK 1

# loop specificando risultati di partenza, di arrivo e di quanto incrementare 
for(page_result in seq(from=10, to=4020, by=10)){
  url<-paste0("https://www.tripadvisor.it/Attraction_Review-g187855-d232103-Reviews-or",page_result,"-Museo_Nazionale_dell_Automobile-Turin_Province_of_Turin_Piedmont.html")
  remDr$navigate(url)
  
  html <- remDr$getPageSource()[[1]]
  html <- read_html(html)
  
  reviews<-html %>% # Name a variable reviews and take a look at the html
    html_elements(".KxBGd .yCeTE") %>% # In particular, look at the class named .cPQsENeY
    html_text() %>% # Grab the text contained with this class
    as_tibble(reviews) # And save it as a tibble to reviews.
  
  dates<-html %>%
    html_elements(".TreSq .ncFvv") %>%
    html_text() %>%
    str_remove_all("Scritta in data ") %>% # Remove unwanted strings
    as_tibble(dates)
  
  title <- html %>%
    html_elements(".ukgoS .yCeTE") %>%
    html_text() %>% # Grab the text contained with this class
    as_tibble(title)
  
  score <- html %>%
    html_elements("#tab-data-qa-reviews-0 .f.k+ div") %>%
    html_children() %>% # Look at the child of the named class
    html_attr("aria-label") %>% # Grab the name of the class of the child
    str_remove_all("Punteggio") %>% # Remove unwanted strings
    str_remove_all("su 5") %>%
    as_tibble(dates)
  
  combined <- bind_cols(dates, title, reviews, score)
  recensioni<-rbind(recensioni, bind_cols(dates, title, reviews, score))
  
  print(paste("Page:", page_result))
  }
  
  
  
  # CHUNK 2


# loop specificando risultati di partenza, di arrivo e di quanto incrementare 
for(page_result in seq(from=4030, to=4030, by=10)){
  url<-paste0("https://www.tripadvisor.it/Attraction_Review-g187855-d232103-Reviews-or",page_result,"-Museo_Nazionale_dell_Automobile-Turin_Province_of_Turin_Piedmont.html")
  remDr$navigate(url)
    
  html <- remDr$getPageSource()[[1]]
  html <- read_html(html)
    
  reviews<-html %>% # Name a variable reviews and take a look at the html
    html_elements(".KxBGd .yCeTE") %>% # In particular, look at the class named .cPQsENeY
    html_text() %>% # Grab the text contained with this class
    as_tibble(reviews) # And save it as a tibble to reviews.
    
  dates<-html %>%
    html_elements("#tab-data-qa-reviews-0 div:nth-child(2) .C .ncFvv.osNWb , #tab-data-qa-reviews-0 div:nth-child(3) .ncFvv.osNWb , .osNWb+ .ncFvv") %>%
    html_text() %>%
    str_remove_all("Scritta in data ") %>% # Remove unwanted strings
    as_tibble(dates)
    
  title <- html %>%
    html_elements(".ukgoS .yCeTE") %>%
    html_text() %>% # Grab the text contained with this class
    as_tibble(title)
  
  score <- html %>%
    html_elements("#tab-data-qa-reviews-0 .f.k+ div") %>%
    html_children() %>% # Look at the child of the named class
    html_attr("aria-label") %>% # Grab the name of the class of the child
    str_remove_all("Punteggio") %>% # Remove unwanted strings
    str_remove_all("su 5") %>%
    as_tibble(dates)
    
  combined <- bind_cols(dates, title, reviews, score)
  recensioni <- rbind(recensioni, bind_cols(dates, title, reviews, score))
  
  print(paste("Page:", page_result))
  }

  
  
  
  
  # CHUNK 3
  
# loop specificando risultati di partenza, di arrivo e di quanto incrementare

for(page_result in seq(from=4040, to=4600, by=10)) {
  url<-paste0("https://www.tripadvisor.it/Attraction_Review-g187855-d232103-Reviews-or",page_result,"-Museo_Nazionale_dell_Automobile-Turin_Province_of_Turin_Piedmont.html")
  remDr$navigate(url)
    
  html <- remDr$getPageSource()[[1]]
  html <- read_html(html)
    
  reviews <- html %>% # Name a variable reviews and take a look at the html
    html_elements(".KxBGd .yCeTE") %>% # In particular, look at the class named .cPQsENeY
    html_text() %>% # Grab the text contained with this class
    as_tibble(reviews) # And save it as a tibble to reviews.
    
  dates <- html %>%
    html_elements(".osNWb+ .ncFvv") %>%
    html_text() %>%
    str_remove_all("Scritta in data ") %>% # Remove unwanted strings
    as_tibble(dates)
    
  title <- html %>%
    html_elements(".ukgoS .yCeTE") %>%
    html_text() %>% # Grab the text contained with this class
    as_tibble(title)
  
  
  score <- html %>%
    html_elements("#tab-data-qa-reviews-0 .f.k+ div") %>%
    html_children() %>% # Look at the child of the named class
    html_attr("aria-label") %>% # Grab the name of the class of the child
    str_remove_all("Punteggio") %>% # Remove unwanted strings
    str_remove_all("su 5") %>%
    as_tibble(dates)
  
  combined <- bind_cols(dates, title, reviews, score)
  recensioni <- rbind(recensioni, bind_cols(dates, title, reviews, score))
    
  print(paste("Page:", page_result))
  }

remDr$close()

c <- c("data","titolo","testo","punteggio")
names(recensioni) <- c

write.xlsx(recensioni, "TripAdvisorMauto.xlsx")

