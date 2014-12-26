#library(fields)
library(caTools)
library(ncdf4)

interp_ts_lin <- function(data, t_full){
	data.dims = dim(data)
	output <- array(data=NA, dim=c(data.dims[1],data.dims[1],t_full))
	hdays = trunc( (t_full/data.dims[3]) / 2)
	for(i in 1:data.dims[3]) {
		if(i % hdays == 0) {
			output[,,i] <- data[,,i]
		}
		else if(i )
		
	return(object)
}

	year <- 1982
	data.rootdir = "~/Documents/Uni/Masterarbeit/"
	data.meta <- nc_open(paste(data.rootdir, "LAIre/raw_data/Global-0.5x0.5.analysis.",year,".nc",sep=""))

	data.meta.time <- length(ncvar_get(data.meta, "time"))
	
	data.name <- paste(data.rootdir,"LAIv3g/hantsout/smoothed/smoothed",year, sep="") 
	data = read.ENVI(data.name)
	
	data.max <- apply(data,c(1,2),max)
	data.min <- apply(data,c(1,2),min)
	data.midpoint <- data.max-data.min
	data.midpoint <- data.min + data.midpoint/2
	#data.dims = dim(data)
	
	#data.aboveMP <- apply(data[73,378,], 3, function(x)  x > data.midpoint[73,378])
	data.aboveMP = data[73,378,] > data.midpoint[73,378]
	data.aboveMP
	
	data.soy <- array(data=NA, dim=data.dims)
	
	for(t in 1:data.dims[3]) {
		temp <- data.[,,t] <
			}
		
	data.ts = ts(data.midpoint, start=c(year,1), frequency=24)
	data.ts
	#write.ENVI(data.min,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_min",sep=""))
	#write.ENVI(data.max,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_max", sep=""))
	#write.ENVI(data.midpoint,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_midpoint", sep=""))
	data[150:160,350:360,]

	data.firstocc = apply(data[150:160,350:360,], c(1,2), function(x) match(x>data.midpoint, x))
	data.firstocc
	write.ENVI(data.firstocc, paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/", year, "_firstocc", sep="") )