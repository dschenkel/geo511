rm(list = ls())

#library(ncdf)
library(raster)
library(fields)
library(ggplot2)
library(caTools)
library(reshape2)
library(rasterVis)
library(colorspace)
library(maps)
library(mapdata)
library(maptools)
library(RColorBrewer)



smooth_image <- function(rstr,x_win,y_win) {
	rstr.out <- focal(rstr, fun=median,w=matrix(1,nrow=x_win,ncol=y_win), na.rm=FALSE)
	return(rstr.out)
}

name_classes <- function(classes,ndig=3) {
	classes.names = character((length(classes)-1))
	classes.names[1] = paste("<=",signif(classes[2],digits=ndig))
	for(i in 2:(length(classes)-2)) {
		classes.names[i] = paste(signif(classes[i],digits=ndig),"-",signif(classes[i+1],digits=ndig))
	}
	classes.names[(length(classes)-1)] = paste(">=",signif(classes[(length(classes)-1)],digits=ndig))

	return(classes.names)
}

classify_image.div <- function(map,classes,divider) {
	map.min = min(map, na.rm=TRUE)
	map.max = max(map, na.rm=TRUE)
	
	if(map.min>0 | map.max<0) {
		return(next)
	}
	
	classes_subz = seq(map.min,ifelse(map.min>= -divider,map.min/2,-divider),length.out=((classes+1)/2))
	classes_abz = seq(ifelse(map.max<=divider,map.max/2,divider),map.max,length.out=((classes+1)/2))
	outclasses = c(classes_subz,classes_abz)
	
	return(outclasses)
	
}

classify_image <- function(map,classes) { #classes = class borders or number of classes
	if(length(classes) == 1) { #assume equal spacing
		map.min = min(map, na.rm=TRUE)
		map.max = max(map, na.rm=TRUE)
		group_size = (map.max-map.min)/classes
		classes = seq(map.min,map.max,by=group_size)
	}
	#map = matrix(c(2, -4, 3, 1, 5, 7), nrow=3,ncol=2)
	#map
	map.out = array(data=NA,dim=dim(map))
	for(i in 1:(length(classes)-1)) {
		if(i==(length(classes)-1)) {
			#print(classes[i])
			#print(classes[i+1])
			map.out[map>=classes[i] & map<=classes[i+1]] <- i
		}
		else {
			#print(classes[i])
			map.out[map>=classes[i] & map<classes[i+1]] <- i			
		}
	}
	return(map.out)
}

boundary_layer <- function(rstr) {
	ext = extent(rstr)
	boundaries <- map('world', fill=TRUE,
	    xlim=ext[1:2], ylim=ext[3:4],
	    plot=FALSE)

	## read the map2SpatialPolygons help page for details
	IDs <- sapply(strsplit(boundaries$names, ":"), function(x) x[1])
	bPols <- map2SpatialPolygons(boundaries, IDs=IDs,
	                              proj4string=CRS(projection(rstr)))
	return(bPols)
}

quickplot <- function(map, classes, classes.names, colors, outname=FALSE,smoothing=FALSE) {
	if(is.vector(classes)) {
		map <- classify_image(map,classes)
	}
	map[map==NA] <- 0
	
	rstr = raster(map)
	
	if(smoothing != FALSE) {
		rstr <- smooth_image(rstr,3,3)
	}
	
	extent(rstr) <- extent(-180, 180, -90, 90)
	
	rstr <- ratify(rstr)

	rat <- levels(rstr)[[1]]
	
	
	rat$classes <- classes.names
	levels(rstr) <- rat
	
	png(filename = outname,
	    width = 850, height = 480, units = "px",
	     bg = "white")
		 

		 wld <- map('world', interior=F,boundary=T, xlim=c(-180,180), 
		 ylim=c(-90,90),plot=FALSE)

		 wld <- data.frame(lon=wld$x, lat=wld$y)


		 #?maps::map

	p0 <- levelplot(rstr, col.regions=colors) +
   xyplot(lat ~ lon, wld, type='l', lty=1, lwd=1, col='black')

	
	print(p0)
	
	dev.off()
 
	#map = apply(map, 2, rev)
	#df = melt(map)
	#colnames(df) <- c("x","y","z")
	#theme_set(theme_bw())
	#p0 <- qplot(df$y, df$x, data = df, fill = z, geom = "raster") + coord_equal() + 
	#	scale_fill_manual(values=c("#FF0000", "#0000FF", "#FF00FF"), 
    #                   name="Dominating Factor",
    #                   labels=c("Temperature", "Moisture", "Radiation"))
	
	
	#print(p0)
}

#filename = "~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/1982_dominating_control"
#mtrx = read.ENVI(filename)

#quickplot(mtrx,classes=FALSE, smoothing=TRUE,outname="/Users/davidschenkel/Documents/Uni/Masterarbeit/test2.png")
