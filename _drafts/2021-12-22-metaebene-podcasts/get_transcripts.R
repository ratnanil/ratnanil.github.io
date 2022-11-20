

library(tidyRSS)
library(tidyverse)

library(rvest)
library(xml2)
library(purrr)
library(dplyr)

feed_urls <- c(
  forschergeist = "https://feeds.metaebene.me/forschergeist/mp3",
  raumzeit = "https://raumzeit-podcast.de/feed/mp3/",
  logbuch_netzpolitik = "https://logbuch-netzpolitik.de/feed/mp3",
  ukw = "https://ukw.fm/feed/mp3/"
  )


rss_xml %>% 
  html_element("item") %>%
  xml_find_all(".//podcast:person") -> persons
  
person_roles <- html_attr(persons, "role")


list(set_names(person_names, person_roles))

rss_additional <- imap_dfr(feed_urls, function(feed, podcast){
  rss_xml <- xml2::read_xml(feed)
  
  
rss_additional <- rss_xml %>%
    html_elements("item") %>% 
    map_dfr(function(x){
      guid <- xml_find_all(x, ".//guid") %>% html_text()
      persons <- xml_find_all(x, ".//podcast:person")
      person_names <- html_text(persons)
      person_roles <- html_attr(persons, "role")
      persons_list <- list(set_names(person_names, person_roles))
      
      
      
      duration <- xml_find_all(x, ".//itunes:duration") %>% html_text()
      enclosure <- xml_find_all(x, ".//enclosure") %>% html_attr("url")
      tibble(guid = guid, persons = persons_list, duration = duration, enclosure = enclosure)
    }) %>%
    mutate(podcast = podcast)
})


save(rss_additional, file = "rss_additional.Rda")



feed_dfr <- imap_dfr(feed_urls, function(x, podcast){
  x_df <- tidyRSS::tidyfeed(x)
  x_df$podcast <- podcast
  x_df
})

write_csv(feed_dfr, "feed_dfr.csv")

feed_dfr <- read_csv("feed_dfr.csv")

feed_dfr <- mutate(feed_dfr, n = row_number())

clean_json <- function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
}

library(zeallot)


feed_dfr %>%
  select(podcast, item_link, item_guid, n) %>%
  # head(1) %>%
  # slice(37) %->% c(podcast, item_link, item_guid, n)
  pmap(function(podcast, item_link, item_guid, n){
    trans <- jsonlite::read_json(paste0(item_link,"?podlove_transcript=json"))
    trans_clean <- lapply(trans, clean_json)
    trans_df <- do.call("rbind",trans_clean) %>% as_tibble()
    
    trans_df$pocast <- podcast
    trans_df$item_link <- item_link
    trans_df$guid <- item_guid
    Sys.sleep(0.1)
    print(paste0("n",n," complete. (",n/max(feed_dfr$n),")"))
    write_csv(trans_df, paste0(n, ".csv"))
  })


transcripts <- map(list.files(pattern = "\\d{1,3}\\.csv"), ~read_csv(.x)) %>%
  bind_rows()

write_csv(transcripts, "transcripts.csv")

list.files(pattern = "\\d{1,3}\\.csv") %>% file.remove()

