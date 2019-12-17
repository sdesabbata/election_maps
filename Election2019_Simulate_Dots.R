##########
# Dot simulation
# Author: Stefano De Sabbata
# Date: 16 December 2019
# Licensed under the GNU General Public License v3.0 https://www.gnu.org/licenses/gpl-3.0.html
##########



# Libraries ---------------------------------------------------------------

library(tidyverse)
library(rgdal)
library(sp)
library(maptools)



# Load data ---------------------------------------------------------------

# Election results data by Alex Denvir https://twitter.com/eldenvo
# https://drive.google.com/file/d/19Z1YbmmjzDqMl2rzrk0XTfNrbRJDAMtU/view
# via # https://twitter.com/VictimOfMaths/status/1205867779007623168
ge2019 <- read_csv("ge2019/GE-2019-results.csv")
ge2019_parties <- c("all", "brx", "con", "dup", "grn", "ind", "lab", "lib", "oth", "plc", "sdl", "snf", "snp", "spk", "ukp", "uup")

# Geographic data by Alasdair Rae
# https://github.com/alasdairrae/wpc
uk_wpc <- readOGR("wpcfiles/uk_wpc_2019_with_data_from_v7.gpkg", "uk_wpc_2019_with_data_from_v7")

# Merge
uk_wpc <- uk_wpc[, c("ccode1", "cname1")]
uk_wpc <- merge(uk_wpc, ge2019, by.x = "ccode1", by.y= "code")



# Simulation --------------------------------------------------------------

# Dots per vote in simulation
votes_per_dot <- 10

# Create empty data frame
uk_wpc_sim_points_df <- NA

# Log
sink("Election2019_Simulate_Dots--log.txt")

# For each constituency
for (i in 1:nrow(uk_wpc)) {
  
  # Print name
  to_log <- paste(i,":", uk_wpc[i, ]@data$cname1)
  cat(to_log, "\n")
  
  # For each party
  # generated a proportional vector of characters with the party id
  votes <- c()
  for(party in ge2019_parties){
    votes <- c(
      votes, 
      rep(
        party, 
        (uk_wpc[i, ]@data[, party] / votes_per_dot) 
          %>% round()
      )
    )
  }
  # Shuffle order
  votes <- sample(votes)
  
  # Create a data frame for the votes
  votes_n <- length(votes)
  votes_df <- data.frame(
      cname1 = rep(uk_wpc[i, ]@data$cname1, votes_n),
      vote = votes
    )
  
  # Generate random points in polygon
  this_uk_wpc_sim_points <- spsample(
    uk_wpc[i, ], 
    n = votes_n , 
    type = "random"
  )
  
  # Print to check numbers
  to_log <- paste("\n\tDots target:", votes_n)
  cat(to_log, "\n")
  to_log <- paste("\n\tDots generated:", length(this_uk_wpc_sim_points@coords[, 1]))
  cat(to_log, "\n")
  
  # Add warning if numbers don't match              
  if (length(this_uk_wpc_sim_points@coords) < votes_n) {
    to_log <- paste("\tMISSING", votes_n - length(this_uk_wpc_sim_points@coords), "dots!")
    cat(to_log, "\n")
  }
  
  # Combine votes and points
  this_uk_wpc_sim_points_df <- SpatialPointsDataFrame(
    this_uk_wpc_sim_points,
    data = votes_df
  )
  
  # Combine with previous constituencies
  if (is.na(uk_wpc_sim_points_df)) {
    uk_wpc_sim_points_df <- this_uk_wpc_sim_points_df
  } else {
    uk_wpc_sim_points_df <- spRbind(uk_wpc_sim_points_df, this_uk_wpc_sim_points_df)
  }
  
  # Newlines
  to_log <- "\n"
  cat(to_log, "\n")
  
}

# Close log file
sink()



# Save --------------------------------------------------------------------

# Write final SpatialPointsDataFrame
writeOGR(
  uk_wpc_sim_points_df, 
  dsn = paste0("dots/ge2019_sim_points_", votes_per_dot,"ppp.gpkg"), 
  layer = "uk_wpc_sim_points", 
  driver = "GPKG"
)

