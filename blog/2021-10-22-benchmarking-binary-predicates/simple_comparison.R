

library(sf)
library(tidyverse)

mypoly <- st_polygon(list(matrix(c(0,0,0,1,1,1,1,0,0,0),byrow = TRUE, ncol = 2)))

point_inside <- st_point(c(0.5,0.5))
point_outside <- st_point(c(1.5,1.5))
point_online <- st_point(c(0,0))

mypoints <- st_sfc(point_inside,point_outside,point_online) %>%
  st_sf() %>%
  mutate(pos = c("inside", "outside","online"))

mypoints[st_within(mypoints,mypoly,sparse = FALSE)[,1],]
mypoints[st_contains(mypoly,mypoints,sparse = FALSE)[1,],]

mypoints[st_intersects(mypoints,mypoly,sparse = FALSE)[,1],]
mypoints[st_covered_by(mypoints,mypoly,sparse = FALSE)[,1],]
