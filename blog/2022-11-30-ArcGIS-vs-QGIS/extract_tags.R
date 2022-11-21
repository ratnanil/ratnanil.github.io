library(tidyverse)
library(xml2)

# https://archive.org/details/stackexchange
xml_posts <- xml2::read_xml("blog/2022-11-30-ArcGIS-vs-QGIS/posts/Posts.xml") 

# https://stackoverflow.com/questions/1390568/how-can-i-match-on-an-attribute-that-contains-a-certain-string

get_questions <- function(tags, xml_posts, attrs = c("Id", "Tags", "AnswerCount","AcceptedAnswerId", "PostTypeId", "CreationDate", "ViewCount", "Score")){
  imap_dfr(tags, function(tag, group){
    children_filter <- xml2::xml_find_all(xml_posts, glue::glue("//row[contains(@Tags, '{tag}')]"))
    
    out_df <- map(attrs, function(attr_i){
      xml2::xml_attr(children_filter,attr = attr_i)
    }) %>%
      set_names(attrs) %>%
      do.call(cbind, .) %>% 
      as_tibble() %>%
      mutate(
        searchtag = tag,
        CreationDate = parse_datetime(CreationDate),
        AnswerCount = as.integer(AnswerCount),
        AcceptedAnswerId = as.integer(AcceptedAnswerId),
        PostTypeId = as.integer(PostTypeId),
        group = group
      )
  })
  
}

arcgis_qgis <- get_questions(c(arcgis = "arcgis", arcgis = "arcpy", qgis = "qgis"),xml_posts)

write_csv(arcgis_qgis, "blog/2022-11-30-ArcGIS-vs-QGIS/gis.stackexchange-tags.csv")
