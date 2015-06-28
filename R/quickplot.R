rm(list = ls())

#library(ncdf)
library(raster)
library(fields)
input.envi = "~/Documents/Uni/Masterarbeit/bimonthly_changes/MOIST_FAC_1"


image.plot(d.lon, d.lat, d.water)

str(d[,,35])
dimnames(d) <- list(d.lon,d.lat,d.time)
str(d)
mean(d)
#max(d[,,"4"])

d[290,41,]
d.max <- apply(d,c(1,2),max)

#library(ggplot2)
#qplot(LAIreDat.lon, LAIreDat.lat, data=d, fill=d, geom= "raster")
#fields::image.plot 
#?image
#library(hyperSpec)
#LAI3g = "../LAIv3g/LAIv3g_8211_INT_BSQ"
