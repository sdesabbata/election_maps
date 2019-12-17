##########
# Make clean file in R
# Author: Stefano De Sabbata
# Date: 17 December 2019
# Licensed under the GNU General Public License v3.0 https://www.gnu.org/licenses/gpl-3.0.html
##########

# Clean R Environment

rm(list = ls())

# Delete downloaded and compiled files

unlink("files", recursive = TRUE)
unlink("ge2019", recursive = TRUE)
unlink("dots", recursive = TRUE)
unlink("maps", recursive = TRUE)

unlink("Election2019_Simulate_Dots--log.txt")

