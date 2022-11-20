
library(httr)
library(xml2)
library(rvest)
library(tidyverse)

services <- read_html("https://geodienste.ch/versions_overview") %>%
  html_elements("a") %>%
  html_attr("href")

services <- services[str_detect(services, "/services/")]


kantone <- read_html("https://geodienste.ch/services/av") %>%
  html_elements(".wappen-kt") %>%
  html_text()

kantone <- str_trim(kantone)
wappen <- read_html("https://geodienste.ch/services/av") %>%
  html_elements(".wappen-kt") %>%
  html_elements("img") %>%
  html_attr("src")

kantone2 <- paste0(kantone,str_extract(wappen, "\\.\\w{3}$"))


map2(kantone2, wappen, function(x,y){
  download.file(paste0("https://geodienste.ch/",y),file.path("wappen",x))
})

fi <- list.files("wappen/",".png", full.names = TRUE)

file.rename(fi, str_remove(fi, " "))


myres <- map(services, function(url_i){
  res <- read_html(paste0("https://geodienste.ch/",url_i)) %>%
    # html_elements(".canton-table") %>%
    html_table() %>%
    magrittr::extract2(1)
  
  res <- res %>% 
    janitor::clean_names()
  
  res %>%
    filter(!is.na(info))
})

res2 <- map2_dfr(myres, services, function(mydf, serv){
  mydf <- mydf[,1:3]
  mydf$services <- serv
  mydf
})

write_csv(res2, "geodienste-raw.csv")
