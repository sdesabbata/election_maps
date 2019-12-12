library(tidyverse)
library(rgdal)
library(tmap)


# Party colours
# https://en.wikipedia.org/wiki/Wikipedia:Index_of_United_Kingdom_political_parties_meta_attributes
party_colours_df <- data.frame(
  party = c("con", "lab", "ld", "ukip", "green", "snp", "pc", "dup", "sf", "sdlp", "uup", "alliance", "other"),
  party_colour = c("#0087DC", "#DC241f", "#FAA61A", "#70147A", "#6AB023", "#FDF38E", "#008142", "#D46A4C", "#326760", "#3A9E84", "#48A5EE", "#F6CB2F", "#f2f2f2")
)

uk_wpc_sim_points_df <- readOGR("uk_wpc_sim_points/uk_wpc_sim_points_10ppp.gpkg", "uk_wpc_sim_points")
uk_wpc_sim_points_df <- merge(uk_wpc_sim_points_df, party_colours, by.x = "vote", by.y = "party")
uk_wpc_sim_points_df$party_colour <- as.character(uk_wpc_sim_points_df$party_colour)

uk_wpc_sim_points_map <- tm_shape(uk_wpc_sim_points_df) +
  tm_layout(
    bg.color = "#000000"
  ) +
  tm_dots(
    col = "party_colour",
    border.alpha = 0,
    size = 0.0001
  ) 

tmap_save(
  uk_wpc_sim_points_map,
  "maps/uk_wpc_sim_points_10ppp_1200dpi.png", 
  width = 210, 
  height = 298,
  units = "mm",
  dpi = 1200
)


#tm_shape(uk_wpc_sim_points_df[1:1000, ]) +
#  tm_layout(
#    bg.color = "#000000"
#  ) +
#  tm_dots(
#    "party_colour",
#    border.alpha = 0,
#    size = 0.1
#  ) 