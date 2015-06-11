install.packages("sp","rgeos")
library(maptools)
library(rgdal)
library(ggplot2)
library(rgeos)
library(plyr)
library(rgeos)

getwd()
setwd("C:/DataAnalysis/Visuals/txt_dat")

##http://libguides.ucd.ie/gisguide/FindSpatialData##
##Read in Ireland Shape File##
dir <- "C:\\DataAnalysis\\Visuals\\EireShape\\Constit"
ie.shp <- readOGR(dir, layer = "Census2011_Constituencies_2013")

#Simplify polygons
#ie.simp <- gSimplify(ie.shp, tol=0.01, topologyPreserve=TRUE)


##Read in CSV##
small_geo_data <- read.csv(file = "Constit.txt", header=TRUE, sep="\t", na.string=0, strip.white=TRUE)
##for some reason 0 is coming in as NA so replace with 0
small_geo_data$id[is.na(small_geo_data$id)] <- 0
View(small_geo_data)

##Merge
ie.df <- fortify(ie.shp)
combined.df <- join(small_geo_data, ie.df, by="id")
View(ie.df)

ggp <- ggplot(data=combined.df, aes(x=long, y=lat, group=group)) 
ggp <- ggp + geom_polygon(aes(fill=Value))  
ggp <- ggp + geom_path(color="black", linestyle=2)  # draw boundaries
ggp <- ggp + coord_equal() + scale_fill_distiller(palette = "Greens")
ggp <- ggp + labs(title="Ireland Marriage Referendum Results") #+ scale_fill_discrete(name = " % Yes")
# render the map
#print(ggp)

ggsave("Ireland.png", ggp, width=14, height=10, units="in")
