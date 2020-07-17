#Project R Script


library(ggplot2)
library(raster)
library(dplyr)
install.packages('tidymodels')
library(tidymodels)
install.packages('devtools')
install.packages('svglite')
library(patchwork)

#A short description of your project
#A segment of R code that:
#Imports data
#cleans and reformats as necessary
#develops at least one high quality visualization
#A copy of the figure you created
#Include comments to document what your code is doing

#downloaded 3 different data frames, one on extension rates, one on site list and one on model output.

coral = read.csv('http://dmoserv3.bco-dmo.org/jg/serv/BCO-DMO/Coral_Reef_Adjustment/extension_rates.flat0?', sep = "", na.strings = c('nd'))
head(coral)

sites_data = read.csv('http://dmoserv3.bco-dmo.org/jg/serv/BCO-DMO/Coral_Reef_Adjustment/site_list.flat0?', sep = "", na.strings = c('nd'))
head(sites_data)

model_data = read.csv('http://dmoserv3.bco-dmo.org/jg/serv/BCO-DMO/Coral_Reef_Adjustment/model_output.flat0?',sep = "", na.strings = c('nd'))
head(model_data)



ggplot(data = coral, aes(x= species)) + 
  labs(x= 'Species' , title = 'Coral Species and Their Annual Extension') + 
  geom_bar() + theme_classic() + scale_color_viridis_d(option = 'magma')

ggsave('coral_species_bar_graph.png', dpi = 300)


#filter data for model data to just get Palau data for plotting on Palau map 
palau_model_data <- model_data %>% filter(Country == 'Palau')

palau_sites_data <- sites_data %>% filter(country == 'Palau')


ggplot(data = palau_model_data, aes(x= lon, y = lat)) + 
  labs(x= 'longitude' , y = 'latitude' , title = 'lat vs long') + 
  geom_point() + theme_classic() + scale_color_viridis_d(option = 'magma')

#retrieving the Palau map
palau = getData('GADM', country='Palau', level = 0)
plot(palau)

#zoomed out
ggplot() + geom_polygon(data=palau, aes(x=long, y=lat, group=group), fill= "white" , color= "black") + 
  geom_point(data=palau_model_data, aes(x=lon, y=lat, color = 'red')) + coord_quickmap() +labs( title = 'Palau Island Study Sites')

ggplot() + geom_polygon(data=palau, aes(x=long, y=lat, group=group), fill= "white" , color= "black") + 
  geom_point(data=palau_model_data, aes(x=lon, y=lat, fill = 'NP')) + coord_quickmap() +labs( title = 'Palau Island Study Sites')

#zoomed in map of Palau with plots of study sites colored by Net Carbonate Production
sites_location_map_p <- ggplot() + 
  geom_polygon(data=palau, aes(x=long, y=lat, group=group), fill= "green" , color= "black") + 
  xlim(134, 135) + ylim(6.5, 8.3)+ 
  geom_point(data=palau_model_data, aes(x=lon, y=lat,color = NP), size = 1) + 
  coord_quickmap() +labs( x= 'Latitude', y = 'Longitude', title = 'Palau Island Study Locations', col = 'Net Carbonate 
  Production (kg CaCO3 yr-1)') + theme_bw()
print(sites_location_map_p)
#saves the image created 
ggsave('Palau_map_w_points.png', dpi = 300)


#make new data frame combining model_data and sites_data
sites_and_models <- merge(model_data, sites_data ,by=c("lat","lon"))
head(sites_and_models)

#possible mutate to put lat and lon in same column? 
lat_lon <- mutate(sites_and_models, lat_lon = lat,lon)
head(lat_lon)

palau_sites_and_models <- sites_and_models %>% filter(country == 'Palau', Country == 'Palau')
head(palau_sites_and_models)
#make a scatter plot of lat and long and color by other columns

net_cp_scatterplot <- ggplot() + geom_point(data = palau_sites_and_models, aes( x= lat, y = lon , color = NP)) +
  labs( x = 'Latitude', y = 'Longitude', title = 'Net Carbonate Production at 
        Each Palau location') + theme_test()
print(net_cp_scatterplot)

#saves the image created
ggsave('Palau_np_scatterplot.png', dpi = 300)

#put two graphs together
sites_location_map_p + net_cp_scatterplot + plot_layout(nrow =2) + plot_annotation(tag_levels = "A")

#scatterplot of site and np
npvssite_scatterplot <- ggplot() + geom_point(data = palau_sites_and_models, aes( x= site, y = NP, color = locat )) +
  labs( x = 'Site', y = 'Net Carbonate Production', title = 'Net Carbonate Production at 
        Each Palau site', col= 'Reef Types') + scale_colour_viridis_d() +theme_test()
print(npvssite_scatterplot)

npvssite_scatterplot + net_cp_scatterplot + plot_layout(nrow =2) + plot_annotation(tag_levels = "A")

map_and_np_locats <- sites_location_map_p + npvssite_scatterplot + plot_layout(nrow =2) +
  plot_annotation(tag_levels = "A") 
print(map_and_np_locats)
ggsave('Palau_map_and_np_locats.png', dpi = 300, width = 7, height =6 )
