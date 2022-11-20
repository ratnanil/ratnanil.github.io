library(sf)
library(tidyverse)


# kantone_sf <- read_sf("data/Switzerland_Tilemap-master/data/Switzerland_Tiles_CH1903LV95.shp") %>%
#   filter(str_detect(Name, "[A-Z]{2}"))

hauptkantone <- tibble::tribble(
  ~kanton1, ~kanton2, ~hauptkanton,
  "BL", "BS", "BL-BS",
  "OW", "NW", "OW-NW",
  "AI", "AR", "AI-AR",
) %>%
  pivot_longer(starts_with("kanton")) %>%
  mutate(kanton = value) %>%
  select(-name)

cents <- kantone_sf %>%
  left_join(hauptkantone, by = c(Name = "kanton")) %>% 
  mutate(hauptkanton = ifelse(is.na(hauptkanton),Name,hauptkanton)) %>%
  group_by(hauptkanton) %>%
  summarise() %>% 
  st_centroid()

# my_grid <-
  cbind(st_drop_geometry(cents), st_coordinates(cents)) %>%
  as_tibble() %>%
    mutate(
      asp = 10/(diff(range(X))/diff(range(Y))),
      row = round(scales::rescale(Y, c(1,7.75)),1),
      col = round(scales::rescale(X, c(1,10)),1),
    ) %>%
    # transmute(code = hauptkanton, name = hauptkanton, row, col)  %>%
    ggplot(aes(col, row, label = paste(hauptkanton, row,"/", col))) + geom_label() + coord_equal()


geofacet::grid_preview(geofacet::ch_cantons_grid2)
write_csv(my_grid, "my_grid.csv")

kantone_join3 <- kantone_join2 %>%
  left_join(hauptkantone, by = c(abk = "value")) %>%
  mutate(hauptkanton = ifelse(is.na(hauptkanton),abk,hauptkanton)) %>%
  mutate(code = hauptkanton, name = hauptkanton)
  
library(geofacet)
library(ggwaffle)

kantone_join2 <- kantone_join2 %>%
  mutate(
    code = abk,
    name = abk
  )


dat2 <- kantone_join2 %>%
  mutate(title.de = fct_explicit_na(title.de, na_level = "")) %>%
  mutate(
    package_count = ceiling(package_count/10),
    n = map(package_count, ~rep(1, .x)),
    code = as.character(code),
    title.de = as.character(title.de),
    ) %>%
  unnest(n) %>% 
  mutate(
    title.de = fct_lump(title.de,4, other_level = "zzz andere"),
    title.de = as.character(title.de)
    ) %>% 
  group_by(code) %>%
  group_nest() %>%
  mutate(waff = map(data, ~waffle_iron(.x, aes_d(group = title.de), rows = 10))) %>%
  unnest(waff) %>%
  mutate(
    group = fct_recode(group, andere = "zzz andere"),
    group = fct_relevel(group, "andere", after = Inf)
    )
mt <- crossing(
  x = seq(range(dat2$x)[1], range(dat2$x)[2]),
  y = seq(range(dat2$y)[1], range(dat2$y)[2]),
  val = 1
)
c(RColorBrewer::brewer.pal(5, "Dark2")) -> cols
colour <- "white"
lwd = .5
ggplot(dat2, aes(y, x)) +
  geom_tile(data = mt, colour = colour, lwd = lwd, fill = "grey", alpha = 0.3) +
  geom_tile(aes(fill = group), colour = "white",lwd = lwd) +
  scale_fill_manual(values =  cols) +
  coord_equal(expand = FALSE) +
  # theme_minimal() +
  theme(legend.position = "bottom", panel.background = element_blank(),strip.text.x = element_text(margin = margin(1,0,1,0, "mm")),
        axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank(), legend.title = element_blank()) +
  facet_geo(facets = ~code, grid = "ch_cantons_grid2") -> p
p


kantone_join2 %>%
  group_by(abk, title.de) %>%
  group_nest()  %>%
  mutate(n = map(data, ~rep(1, .x$package_count))) %>%
  unnest(n) %>%
  transmute(abk2 = paste(abk, title.de, sep = ";"), n) %>%
  waffle_iron(aes_d(group = abk2),rows = 50) %>%
  separate(group, c("abk","title.de"), ";",fill = "left") %>%
  ggplot(aes(x, y, fill = abk)) +
  geom_tile(colour = "white") +
  # geom_waffle(lwd = .1) +
  coord_equal() +
  theme_void() 
