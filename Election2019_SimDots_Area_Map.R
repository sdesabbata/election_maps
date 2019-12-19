##########
# Constituency or region dot map
# Author: Stefano De Sabbata
# Date: 16 December 2019
# Licensed under the GNU General Public License v3.0 https://www.gnu.org/licenses/gpl-3.0.html
##########



# Define subset -----------------------------------------------------------

# Use

# Geographic data by Alasdair Rae
# https://github.com/alasdairrae/wpc
uk_wpc <- readOGR("wpc/files/uk_wpc_2019_with_data_from_v7.gpkg", "uk_wpc_2019_with_data_from_v7")

constituencies_areas <- uk_wpc@data %>%
  select(cname1, county, ukpart, ukcountry)

# Set area type as one of the following:
# "county", "ukpart", "ukcountry"
area_type <- "county"

# Set area name
area_name <- "Leicestershire"

# Retrieve constituencies
constituencies <- constituencies_areas %>%
  filter_(paste(area_type, "== area_name")) %>%
  pull(cname1)


# Define your list of constituencies

# Area name
#area_name <- "Leicester"
# List of constituencies
#constituencies <- c("Leicester East", "Leicester South", "Leicester West")


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



# Subset data -------------------------------------------------------------


# Subset points using bbox
sim_points_df_bboxed <- sim_points_df[
  uk_wpc[
    uk_wpc$cname1 %in% constituencies, 
    ]
  , ]



# Map ---------------------------------------------------------------------

# Define map
uk_wpc_sim_points_map <- tm_shape(
    sim_points_df_bboxed,
  ) +
  tm_layout(
    bg.color = "#000000",
    outer.bg.color = "#000000",
    #title = paste("UK General Election 2019 -", area_name),
    title = paste0("UK General Election 2019\n", area_name),
    title.color = "#FFFFFF",
    title.position = c("left", "top")
  ) +
  tm_dots(
    col = "party_colour",
    border.alpha = 0,
    size = 0.0025
  ) +
  tm_credits(
    "1 dot = 10 votes",
    position=c("left", "top"),
    align = "left",
    col = "#FFFFFF"
  ) +
  tm_credits(
    "v0.1 18/12/2019\nby Stefano De Sabbata @maps4thought\nElection results data (not verified) by Alex Denvir @eldenvo\nGeographic data by Alasdair Rae @undertheraedar",
    position=c("right", "top"),
    align = "right",
    col = "#FFFFFF"
  )


# Save 1 ------------------------------------------------------------------

# Resolution
map_dpi = 1200

# Save
tmap_save(
  uk_wpc_sim_points_map,
  paste0("maps/ge2019_sim_points_10ppp_", str_remove(area_name, " "), "_", map_dpi, "dpi.png"), 
  width = 298, 
  height = 210,
  units = "mm",
  dpi = map_dpi
)


# Save 2 ------------------------------------------------------------------

# Resolution
map_dpi = 150

# Save
tmap_save(
  uk_wpc_sim_points_map,
  paste0("maps/ge2019_sim_points_10ppp_", str_remove(area_name, " "), "_", map_dpi, "dpi.png"), 
  width = 298, 
  height = 210,
  units = "mm",
  dpi = map_dpi
)