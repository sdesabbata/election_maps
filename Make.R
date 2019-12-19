##########
# Make file in R
# Author: Stefano De Sabbata
# Date: 17 December 2019
# Licensed under the GNU General Public License v3.0 https://www.gnu.org/licenses/gpl-3.0.html
##########


# Un comment the install.packages command below
# if the related library is not installed
#install.packages("googledrive")
#install.packages("tidyverse")
#install.packages("rgdal")
#install.packages("sp")
#install.packages("maptools")
#install.packages("tmap")


# Step 0: Make clean
source("Make_Clean.R")

# Step 1: Get data and set up
source("Setup.R")

# Step 2: Generate simulated dots data
source("Election2019_Simulate_Dots.R")

# Step 3: Generate map
source("Election2019_SimDots_Map.R")

# or use Election2019_SimDots_Area_Map.R 
# to create local area maps