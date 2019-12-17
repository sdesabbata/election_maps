##########
# Setup
# Author: Stefano De Sabbata
# Date: 16 December 2019
# Licensed under the GNU General Public License v3.0 https://www.gnu.org/licenses/gpl-3.0.html
##########


# Clone wpc repo by Alasdair Rae to a tmp folder
# https://github.com/alasdairrae/wpc
system("git clone https://github.com/alasdairrae/wpc.git ../wpc---tmp")

# Create wpc dir if necessary
ifelse(!dir.exists(file.path(".", "wpc")), dir.create(file.path(".", "wpc")), FALSE)

# Copy geographic data from
file.copy("../wpc---tmp/files", "./wpc/", recursive=TRUE)

# Delete tmp folder
unlink("../wpc---tmp", recursive = TRUE)


# Create ge2019 dir if necessary
ifelse(!dir.exists(file.path(".", "ge2019")), dir.create(file.path(".", "ge2019")), FALSE)

# Download election results data using googledrive
# NOTE: requires granting Tidyverse API Packages permission to
# see, edit, create and delete all of your Google Drive files
library("googledrive")
drive_download(
  as_id(
    "https://drive.google.com/file/d/19Z1YbmmjzDqMl2rzrk0XTfNrbRJDAMtU"
  ), 
  path = "ge2019/GE-2019-results.csv", 
  overwrite = TRUE
)


# Create dots dir if necessary
ifelse(!dir.exists(file.path(".", "dots")), dir.create(file.path(".", "dots")), FALSE)