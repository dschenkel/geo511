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

d.water = rotate270(d.water)
d.water.NHEM <- array(data=0, dim=c(360,720))
d.water.NHEM[1:180,] <- d.water[1:180,] 
d.water.SHEM <- array(data=0, dim=c(360,720))
d.water.SHEM[181:360,] <- d.water[181:360,]

# specify extent and projection
#extent(d.waterrst) <- extent(c(-180, 180, -90, 90))
#projection(d.waterrst) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

filename.nhem <- "~/Documents/Uni/Masterarbeit/watermask/watermask_nhem"
writeRaster(raster(d.water.NHEM), filename=filename.nhem, format="ENVI", overwrite=TRUE)


filename.shem <- "~/Documents/Uni/Masterarbeit/watermask/watermask_shem"
writeRaster(raster(d.water.SHEM), filename=filename.shem, format="ENVI", overwrite=TRUE)

#library(ggplot2)
#qplot(LAIreDat.lon, LAIreDat.lat, data=d, fill=d, geom= "raster")
#fields::image.plot 
#?image
#library(hyperSpec)
#LAI3g = "../LAIv3g/LAIv3g_8211_INT_BSQ"
