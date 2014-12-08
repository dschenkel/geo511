rm(list = ls())

library(ncdf)
library(fields)
LAIre = "~/Documents/Uni/Masterarbeit/Global_prediction_0.5/Global-0.5x0.5.analysis.1985.nc"
# ??open.ncdf
nc <- open.ncdf(LAIre)
nc
c <- get.var.ncdf(nc, "ens")

d <- get.var.ncdf(nc, "TEMP_FAC")
str(d)
d.lat <- get.var.ncdf(nc, "lat")
d.lon <- get.var.ncdf(nc, "lon")
d.time <- get.var.ncdf(nc, "time")
dimnames(d) <- list(d.lon,d.lat,d.time)
str(d)
mean(d)
#max(d[,,"4"])

d[290,41,]
d.max <- apply(d,c(1,2),max)
image.plot(d.lon, d.lat, d.max)
#library(ggplot2)
#qplot(LAIreDat.lon, LAIreDat.lat, data=d, fill=d, geom= "raster")
#fields::image.plot 
#?image
#library(hyperSpec)
#LAI3g = "../LAIv3g/LAIv3g_8211_INT_BSQ"
