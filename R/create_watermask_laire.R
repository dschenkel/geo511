rm(list = ls())

library(ncdf)
library(raster)
library(fields)

rotate <- function(x) t(apply(x, 2, rev))

rotate270 <- function(x) rotate(rotate(rotate(x)))

LAIre = "~/Documents/Uni/Masterarbeit/LAIre/raw_data/Global-0.5x0.5.analysis.1982.nc"
# ??open.ncdf
nc <- open.ncdf(LAIre)
nc
c <- get.var.ncdf(nc, "ens")

d.lat <- get.var.ncdf(nc, "lat")
d.lon <- get.var.ncdf(nc, "lon")
d.time <- get.var.ncdf(nc, "time")
d <- get.var.ncdf(nc, "PFT_PCT")
d.water <- d[,,35]
#d.water
max(d.water)
d.water[d.water <= 60] <- 1
d.water[d.water > 60] <- 0

d.waterrst = raster(rotate270(d.water))

# specify extent and projection
#extent(d.waterrst) <- extent(c(-180, 180, -90, 90))
#projection(d.waterrst) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

filename <- "~/Documents/Uni/Masterarbeit/watermask/watermask82"
writeRaster(d.waterrst, filename=filename, format="ENVI", overwrite=TRUE)

#library(ggplot2)
#qplot(LAIreDat.lon, LAIreDat.lat, data=d, fill=d, geom= "raster")
#fields::image.plot 
#?image
#library(hyperSpec)
#LAI3g = "../LAIv3g/LAIv3g_8211_INT_BSQ"
