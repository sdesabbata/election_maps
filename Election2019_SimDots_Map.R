##########
# Dot map
# Author: Stefano De Sabbata
# Date: 16 December 2019
# Licensed under the GNU General Public License v3.0 https://www.gnu.org/licenses/gpl-3.0.html
##########



# Libraries ---------------------------------------------------------------

library(tidyverse)
library(rgdal)
library(tmap)



# Load data ---------------------------------------------------------------

# Load dots
sim_points_df <- readOGR("dots/ge2019_sim_points_10ppp.gpkg", "uk_wpc_sim_points")

# Set party colours
# https://en.wikipedia.org/wiki/Wikipedia:Index_of_United_Kingdom_political_parties_meta_attributes
party_colours_df <- data.frame(
  party = c("all", "brx", "con", "dup", "grn", "ind", "lab", "lib", "oth", "plc", "sdl", "snf", "snp", "spk", "ukp", "uup"),
  party_colour = c("#F6CB2F", "#12B6CF", "#0087DC", "#D46A4C", "#6AB023", "#DDDDDD", "#DC241f", "#FAA61A", "#999999", "#008142", "#2AA82C", "#326760", "#FDF38E", "#FFFFFF", "#70147A", "#48A5EE")
)

# Merge with party colours
sim_points_df <- merge(sim_points_df, party_colours_df, by.x = "vote", by.y = "party")
sim_points_df$party_colour <- as.character(sim_points_df$party_colour)



# Map ---------------------------------------------------------------------

# Define map
uk_wpc_sim_points_map <- tm_shape(
    sim_points_df
  ) +
  tm_layout(
    bg.color = "#000000",
    outer.bg.color = "#000000",
    title = "UK General Election 2019",
    title.color = "#FFFFFF"
  ) +
  tm_dots(
    col = "party_colour",
    border.alpha = 0,
    size = 0.0001
  ) +
  tm_credits(
    "1 dot = 10 votes\n\nby Stefano De Sabbata @maps4thought\nv0.1 18/12/2019\n\nElection results data (not verified) by Alex Denvir @eldenvo\nGeographic data by Alasdair Rae @undertheraedar",
    position=c("left", "top"),
    col = "#FFFFFF"
  )


# Save 1 ------------------------------------------------------------------

# Resolution
map_dpi = 1200

# Save
tmap_save(
  uk_wpc_sim_points_map,
  paste0("maps/ge2019_sim_points_10ppp_", map_dpi, "dpi.png"), 
  width = 210, 
  height = 298,
  units = "mm",
  dpi = map_dpi
)

# Save 2 ------------------------------------------------------------------

# Resolution
map_dpi = 150

# Save
tmap_save(
  uk_wpc_sim_points_map,
  paste0("maps/ge2019_sim_points_10ppp_", map_dpi, "dpi.png"), 
  width = 210, 
  height = 298,
  units = "mm",
  dpi = map_dpi
)