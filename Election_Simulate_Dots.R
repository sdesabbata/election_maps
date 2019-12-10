library(tidyverse)
library(rgdal)
library(sp)
library(maptools)


uk_wpc <- readOGR("files/uk_wpc_2019_with_data_from_v7.gpkg", "uk_wpc_2019_with_data_from_v7")

votes_per_dot <- 10

uk_wpc_sim_points_df <- NA

log_file <- file("Election_Simulate_Dots--log.txt")

for (i in 1:nrow(uk_wpc)) {
  
  to_log <- paste(i,":", uk_wpc[i, ]@data$cname1)
  cat(to_log)
  writeLines(to_log, log_file)
  
  this_valid17 <- uk_wpc[i, ]@data$valid17
  
  votes <- sample(
    c(
      rep("con", (uk_wpc[i, ]@data$con / votes_per_dot) %>% round()),
      rep("lab", (uk_wpc[i, ]@data$lab / votes_per_dot) %>% round()),
      rep("ld", (uk_wpc[i, ]@data$ld / votes_per_dot) %>% round()),
      rep("ukip", (uk_wpc[i, ]@data$ukip / votes_per_dot) %>% round()),
      rep("green", (uk_wpc[i, ]@data$green / votes_per_dot) %>% round()),
      rep("snp", (uk_wpc[i, ]@data$snp / votes_per_dot) %>% round()),
      rep("pc", (uk_wpc[i, ]@data$pc / votes_per_dot) %>% round()),
      rep("dup", (uk_wpc[i, ]@data$dup / votes_per_dot) %>% round()),
      rep("sf", (uk_wpc[i, ]@data$sf / votes_per_dot) %>% round()),
      rep("sdlp", (uk_wpc[i, ]@data$sdlp / votes_per_dot) %>% round()),
      rep("uup", (uk_wpc[i, ]@data$uup / votes_per_dot) %>% round()),
      rep("alliance", (uk_wpc[i, ]@data$alliance / votes_per_dot) %>% round()),
      rep("other", (uk_wpc[i, ]@data$other / votes_per_dot) %>% round())
    )
  )
  
  votes_n <- length(votes)
  
  votes_df <- data.frame(
      cname1 = rep(uk_wpc[i, ]@data$cname1, votes_n),
      vote = votes
    )
  
  this_uk_wpc_sim_points <- spsample(
    uk_wpc[i, ], 
    n = votes_n , 
    type = "random"
  )
  
  to_log <- paste("\n\tValid votes:", this_valid17)
  cat(to_log)
  writeLines(to_log, log_file)
  
  to_log <- paste("\n\tDots target:", votes_n)
  cat(to_log)
  writeLines(to_log, log_file)
  
  to_log <- paste("\n\tDots generated:", length(this_uk_wpc_sim_points@coords[, 1]))
  cat(to_log)
  writeLines(to_log, log_file)
                  
  if (length(this_uk_wpc_sim_points@coords) < votes_n) {
    to_log <- paste("\tMISSING", votes_n - length(this_uk_wpc_sim_points@coords), "dots!")
    cat(to_log)
    writeLines(to_log, log_file)
  }
  
  this_uk_wpc_sim_points_df <- SpatialPointsDataFrame(
    this_uk_wpc_sim_points,
    data = votes_df
  )
  
  if (is.na(uk_wpc_sim_points_df)) {
    uk_wpc_sim_points_df <- this_uk_wpc_sim_points_df
  } else {
    uk_wpc_sim_points_df <- spRbind(uk_wpc_sim_points_df, this_uk_wpc_sim_points_df)
  }
  
  to_log <- "\n\n"
  cat(to_log)
  writeLines(to_log, log_file)
  
}

close(log_file)

writeOGR(
  uk_wpc_sim_points_df, 
  dsn = paste0("uk_wpc_sim_points/uk_wpc_sim_points_", votes_per_dot,"ppp.gpkg"), 
  layer = "uk_wpc_sim_points", 
  driver = "GPKG"
)

