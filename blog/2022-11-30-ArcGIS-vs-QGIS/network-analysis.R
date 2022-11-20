arcgis_qis_extracted <- gis_stackexchange_tags %>%
  mutate(Tags = map(str_match_all(Tags,"<(.*?)>"), ~.x[,2])) 

arcgis_qgis_long <- arcgis_qis_extracted%>% 
  unnest_longer(Tags)

arcgis_qgis_tagscor <- arcgis_qgis_long %>%
  select(Id, Tags) %>%
  split(.$Id) %>%
  map_dfr(function(dat) {
    vec <- dat$Tags
    if (length(vec) > 1) {
      ret <-  apply(combn(sort(vec), 2), 2, function(x) {paste(x[1], x[2], sep = "<->")})
    } else{
      ret <- paste(vec, "", sep = "<->")      
    }
    tibble(tags = ret)
  }) %>%
  group_by(tags) %>%
  count() %>%
  separate(tags, c("tag1", "tag2"), "<->")


library(igraph)
library(ggraph)
arcgis_qgis_tagscor %>%
  slice_max(order_by = n, n = 50) %>%
  # mutate(across(where(is.character), ~str_trim(.,"both")))
  graph_from_data_frame(directed = FALSE) %>%
  ggraph(layout = "fr") +
  geom_edge_link(aes(edge_colour = n), show.legend = TRUE) +
  geom_node_point() +
  ggraph::scale_edge_alpha(guide = "none") +
  ggraph::scale_edge_colour_gradient(low = "blue",high = "red") +
  geom_node_label(aes(label = name), vjust = 1, hjust = 1, repel = TRUE) +
  ggraph::theme_graph()
