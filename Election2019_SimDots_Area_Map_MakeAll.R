##########
# Constituency or region dot map
# Author: Stefano De Sabbata
# Date: 16 December 2019
# Licensed under the GNU General Public License v3.0 https://www.gnu.org/licenses/gpl-3.0.html
##########



# Libraries ---------------------------------------------------------------

library(tidyverse)
library(rgdal)
library(tmap)



# Define subset -----------------------------------------------------------

# Geographic data by Alasdair Rae
# https://github.com/alasdairrae/wpc
uk_wpc <- readOGR("wpc/files/uk_wpc_2019_with_data_from_v7.gpkg", "uk_wpc_2019_with_data_from_v7")

constituencies_areas <- uk_wpc@data %>%
  select(cname1, county, ukpart, ukcountry)

all_counties <- constituencies_areas %>% pull(county) %>% as.character() %>% unique()
all_ukparts <- constituencies_areas %>% pull(ukpart) %>% as.character() %>% unique()
all_ukcountries <- constituencies_areas %>% pull(ukcountry) %>% as.character() %>% unique()


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


# Map function ------------------------------------------------------------

make_dot_map <- function(area_type, area_name, dot_size){

  # Retrieve constituencies
  constituencies <- constituencies_areas %>%
    filter_(paste(area_type, "== area_name")) %>%
    pull(cname1) %>%
    as.character()
  
  
  
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
      title.position = c("left", "top"),
      asp = 1
    ) +
    tm_dots(
      col = "party_colour",
      border.alpha = 0,
      size = dot_size
    ) +
    tm_credits(
      "1 dot = 10 votes",
      position=c("left", "top"),
      align = "left",
      col = "#FFFFFF"
    ) +
    tm_credits(
      "CC BY-SA 4.0\nby Stefano De Sabbata @maps4thought\ngithub.com/sdesabbata/election_maps\nIncludes data from House of Commons Library,\nmySociety, Office for National Statistics,\nOrdnance Survey,  Alasdair Rae @undertheraedar,\n and Alex Denvir @eldenvo",
      position=c("right", "bottom"),
      align = "right",
      size = 0.5,
      col = "#FFFFFF"
    )
  
  
  # Save 1 ------------------------------------------------------------------
  
  # Resolution
  map_dpi = 1200
  
  # Save
  tmap_save(
    uk_wpc_sim_points_map,
    paste0("maps_all_areas/ge2019_sim_points_10ppp_", str_remove_all(area_name, " "), "_", map_dpi, "dpi.png"), 
    width = 210, 
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
    paste0("maps_all_areas/ge2019_sim_points_10ppp_", str_remove_all(area_name, " "), "_", map_dpi, "dpi.png"), 
    width = 210, 
    height = 210,
    units = "mm",
    dpi = map_dpi
  )

}


# Make all maps -----------------------------------------------------------

for (this_county in all_counties) {
  make_dot_map("county", this_county, 0.0025)
}

for (this_ukpart in all_ukparts) {
  make_dot_map("ukpart", this_ukpart, 0.0005)
}

for (this_ukcountry in all_ukcountries) {
  make_dot_map("ukcountry", this_ukcountry, 0.0001)
}
