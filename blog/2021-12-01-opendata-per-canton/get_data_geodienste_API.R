
library(httr)
library(xml2)
library(rvest)
library(tidyverse)

library(readr)
resp <- GET("https://www.geodienste.ch/info/services.csv?language=de")
csv <- rawToChar(resp$content)
dat <- read_delim(csv, ";")


dat_sel <- dat %>%
  select(contains(c("topic","publication_wms","canton"))) %>%
  filter(grepl("[A-z]{2}",canton),!is.na(topic_title)) 

dat_sel %>%
  transmute(canton, topic = paste(topic_title, base_topic, topic, sep = "_")) %>%
  mutate(val = TRUE) %>%
  pivot_wider(names_from = topic, values_from = val) %>% View()


  group_by(canton) %>% count %>% View
  group_by(across(contains(c("topic","publication_wms","canton")))) %>%
  count()

problems()

