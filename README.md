# BIO316_2020_project
code for summer 2020 bio 316 project 


Start date June ~20th 2020
Finish date July 17th 2020

These packages will need to be installed to run the Rmarkdown

install.packages('rmarkdown')
library(rmarkdown)
install.packages('knitr')
library(knitr)

Project Description:
In my Project I am using data from the Biological & Chemical Oceanography Data Management Office. These data sets contain data on coral at specific sites along the coasts of the Islands Palau and Yap. With my code here I used a map of Palau and plotted the locations on top where the studies were conducted. I made a bar graph of species vs annual growth extension. I also made a scatter plot of the net carbonate production (kg CaCO3 yr-1) at each named site (1-25) off the coast of Palau, with the color by what the reef was classified as (inner, outer or patch). The coral is important in producing CaCO3, and plays a key role in reef framework construction. High percentage coral cover can mean high rates of CaCO3 accumulation and possibly rapid reef growth potential.
I am aiming to show the NP of carbonate at certain sites around Palau, and how inner reefs produce on average less carbonate than other reef types, and how they need more coral cover to produce the same amount of carbonate as patch and outer reefs, as shown in this paper:
https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0197077#sec008