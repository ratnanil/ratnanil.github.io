main_plot <- ggplot(mygrid, aes(E, N, color = heading_deg)) +
  # geom_sf(data = bb_ch, inherit.aes = FALSE, fill = bgcol, color = "NA")  +
  geom_point(size = .4) +
  geom_spoke(aes(angle = heading, radius = scales::rescale(dist, 5e3, 10e3))) +
  scale_color_gradientn(colors = mycols) +
  # labs(title = "Warping Switzerland back into shape",
       # subtitle = "How off were the old coordinates?",
       # caption = "The spokes show the offset between EPSG 21781 and EPSG 2056.\nData from swisstopo. Visualized by Nils Ratnaweera") +
  coord_equal() +
  theme_void() +
  theme(legend.position = "none", 
        plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        text = element_text(color = "white"),
        plot.margin = margin(10,200,10,200),
        panel.background = element_rect(colour = NA, fill = bgcol),
        plot.background = element_rect(fill = bgcol,color = NA))
ggdraw(main_plot) +
  draw_plot(legend_plot, .80, .80, .15, .15, scale = 1, 
            hjust = 1,vjust = 1, halign = 1, valign = 3)

ggsave("twitter.png",scale = 2)
