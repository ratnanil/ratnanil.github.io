library(readr)
library(sf)
library(rvest)
library(ckanr)

## Kantonsgrenzen

tmp <- tempdir()
ziptemp <- file.path(tmp, "data.zip")
download.file("https://data.geo.admin.ch/ch.swisstopo.swissboundaries3d-kanton-flaeche.fill/shp/2056/ch.swisstopo.swissboundaries3d-kanton-flaeche.fill.zip",ziptemp)

unzip(ziptemp,exdir = "data")

list.files("data/","HOHEIT|BEZIRK|KANTON", full.names = TRUE) |> 
  file.remove()

## Tilemap


tmp2 <- tempdir()
ziptemp2 <- file.path(tmp, "master.zip")
download.file("https://github.com/ebp-group/Switzerland_Tilemap/archive/refs/heads/master.zip", ziptemp2)

unzip(ziptemp2,exdir = "data")

## kantons namen

table_list <- read_html("https://de.wikipedia.org/wiki/Kanton_(Schweiz)") %>%
  html_table()

table1 <- tibble(table_list[[1]]) %>% janitor::clean_names()
table2 <- tibble(table_list[[2]]) %>% janitor::clean_names()

kantons_namen <- inner_join(table1, table2, by = "kantons_nummer")


write_csv(kantons_namen, "kantons_namen.csv")



## opendata.swiss

# replaced the following code since groups were missing
# library(ckanr)
# ckanr_setup(url = "https://opendata.swiss")
# orgs <- organization_list(as = 'table',limit = 1000,all_fields = TRUE)


# https://stackoverflow.com/questions/52764496/unnesting-a-dataframe-within-a-dataframe
# orgs2 <- do.call(data.frame, orgs) 

# write_csv(orgs2, "data/opendata-swiss-orgs.csv")

library(httr)


res <- GET("https://ckan.opendata.swiss/api/3/action/organization_list?all_fields=true&include_groups=true")

res2 <- content(res, simplifyDataFrame = TRUE)

orgs <- res2$result

replace_null <- function(inp,return_else = NA_character_){if_else(is.null(inp),return_else,inp)}

class(orgs$display_name)
map(orgs$groups, ~.x$capacity)
orgs2 <- orgs %>%
  mutate(
    group_capacity = map_chr(orgs$groups, ~replace_null(.x$capacity)),
    group_name = map_chr(orgs$groups, ~replace_null(.x$name))
  ) %>%
  select(-groups)

orgs2 <- do.call(data.frame, orgs2)


library(rvest)

pol_ebene <- map_chr(orgs2$name, function(x){
  read_html(paste0("https://opendata.swiss/de/organization/",x)) %>%
    html_element("#facet-political_level-collapse a") %>%
    html_text()
})

formats <- map(orgs2$name, function(x){
  read_html(paste0("https://opendata.swiss/de/organization/",x)) %>%
    html_elements("#facet-res_format-collapse .label-default") %>%
    html_text()
})

formats_by_organisation <- map2_dfr(formats,orgs2$name, function(x,y){
  mydf <- as.data.frame(str_match(x, "([\\w\\/]+)\\n\\s+(\\d+)"))
  mydf$name <- y
  mydf
}) %>%
  mutate(
    n = as.integer(V3),
    type = V2,
    original_string = V1
    ) %>% 
  select(name, type, n, original_string)

write_csv(formats_by_organisation, "data/formats_by_organisation.csv")



imap_dfr(formats, function(x, y){
  spli <- str_split_fixed(x, "\\n",4)
  mydf <- as.data.frame(spli)
  mydf$i <- y
  mydf
})


orgs2$politische_ebene <- map_chr(str_split(pol_ebene, "\\n"), ~str_trim(.x[4]))




write_csv(orgs2, "data/opendata-swiss-orgs.csv")





