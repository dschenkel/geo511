rm(list = ls())

library(ncdf4)
library(raster)
library(fields)
library(caTools)




	for(year in 1982:2011){
	rootdir = "~/Documents/Uni/Masterarbeit/LAIre/"
	# ??open.ncdf
	filename <- paste(rootdir,"Global-0.5x0.5.analysis.",year,".nc",sep="")
	nc <- nc_open(filename)

	d <- ncvar_get(nc, "LAI")

	write.ENVI(d, paste(filename,".envi", sep=""), interleave = "bsq" ) 
}