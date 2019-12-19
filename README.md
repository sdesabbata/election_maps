# Election maps

The 2019 UK General Election dot maps provide an overview of the geographic distribution of votes cast per UK constituency during the 2019 UK General Election and its intersection with population density. Each dot represents 10 votes cast for one party in a constituency, and it is colour coded by the [party colour](https://en.wikipedia.org/wiki/Wikipedia:Index_of_United_Kingdom_political_parties_meta_attributes).

The code is released under [Licensed under the GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html). The images contained in this repository are released under [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) License](https://creativecommons.org/licenses/by-sa/4.0/). They contain data from from the [House of Commons Library](https://researchbriefings.parliament.uk/ResearchBriefing/Summary/CBP-7979) under [Open Parliament Licence](https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/), [mySociety](https://www.mysociety.org/wehelpyou/see-a-list-of-every-mp-in-parliament/), [Office for National Statistics](http://geoportal.statistics.gov.uk/) and [Ordnance Survey](https://www.ordnancesurvey.co.uk/opendatadownload/products.html) as [compiled by Alasdair Rae](https://github.com/alasdairrae/wpc) [@undertheraedar](https://twitter.com/undertheraedar), and from the [House of Commons Library](https://researchbriefings.parliament.uk/ResearchBriefing/Summary/CBP-7979) as [compiled by Alex Denvir](https://drive.google.com/file/d/19Z1YbmmjzDqMl2rzrk0XTfNrbRJDAMtU/view) [@eldenvo](https://twitter.com/eldenvo).

## Instructions

To reproduce the dot maps, clone this repository, check the requirements detailed below, and execute the main `Make.R` script.

### Requirements

The scripts included in this repository require `git` to be installed, to retrieve the UK constituencies geographic data from Alasdair Rae's [wpc repository](https://github.com/alasdairrae/wpc), as well as the following R libraries:

- [`tidyverse`](https://www.tidyverse.org/)
- [`googledrive`](https://googledrive.tidyverse.org/)
    - used to retrieve the [election results data](https://drive.google.com/file/d/19Z1YbmmjzDqMl2rzrk0XTfNrbRJDAMtU/view) by Alex Denvir
    - requires granting Tidyverse API Packages permission to see, edit, create and delete all of your Google Drive files
- [`rgdal`](https://cran.r-project.org/web/packages/rgdal/index.html)
- [`sp`](https://cran.r-project.org/web/packages/sp/index.html)
- [`maptools`](https://cran.r-project.org/web/packages/maptools/index.html)
- [`tmap`](https://cran.r-project.org/web/packages/tmap/index.html)
