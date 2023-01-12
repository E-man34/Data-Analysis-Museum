library(RSelenium)
library(rvest)
library(tidyverse)
library(sys)
library(netstat)
library(openxlsx)

# apertura sessione
rD <- rsDriver(browser="firefox", port=4567L, verbose=F)
remDr <- rD[["client"]]
remDr$navigate("https://www.google.com/search?q=mauto&oq=mauto&aqs=chrome.0.0i271j46i175i199i512j69i59j46i512j0i512j0i10i512j0i512j46i175i199i512j46i512j46i10i175i199i512.1321j1j15&sourceid=chrome&ie=UTF-8#lrd=0x478812ba8eef5987:0xcfc6e9696ae6132,1,,,")
Sys.sleep(3)


# accept cookies
remDr$findElement(using = "css selector", '.sy4vM')$clickElement()
Sys.sleep(2)

# più recenti
remDr$findElement(using = "css selector", '.k1U36b:nth-child(2)')$clickElement()
Sys.sleep(2)

# focus sulla schermata recensioni
webEle <- remDr$findElement(using = "css",value = ".review-dialog-list")
Sys.sleep(2)


# Scroll down 10000 times
scroll_down_times=25000
for(i in 1 :scroll_down_times) {
  webEle$sendKeysToElement(sendKeys = list("key"="page_down"))
  # wait 1 second every 5 scroll downs
  if(i%%5==0){
    Sys.sleep(2)
  }
}

# loop and simulate clicking on all "click on more" elements
webEles <- remDr$findElements(using = "css",value = ".review-more-link")
for(webEle in webEles){
  tryCatch(webEle$clickElement(),error=function(e){print(e)}) # trycatch to prevent any error from stopping the loop
}

pagesource= remDr$getPageSource()[[1]] # naviga nell'URL specificato

# RECENSIONE
reviews=read_html(pagesource) %>%
  html_nodes(".Jtu6Td") %>%
  html_text() %>%
  as_tibble()


# RATING
stars <- read_html(pagesource) %>%
  html_node(".review-dialog-list") %>%
  html_nodes("g-review-stars > span") %>%
  html_attr("aria-label") %>%
  as_tibble()

# DATA
data <- read_html(pagesource) %>%
  html_nodes(".dehysf") %>%
  html_text() %>%
  as_tibble()

# unione in un dataframe
combined<-cbind(data, reviews, stars)
write.xlsx(combined, "GoogleMapsMauto.xlsx")


