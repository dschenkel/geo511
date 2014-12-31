#library(fields)
library(caTools)
library(ncdf4)

plotpixel <- function(time)


data.rootdir = "~/Documents/Uni/Masterarbeit/"
data.mask <- read.ENVI(paste(data.rootdir,"watermask/watermask.envi",sep=""))
lainame= "LAIv3g"

year.min = 1982
year.max = 2011

for(year in year.min:year.max) {
	data.meta <- nc_open(paste(data.rootdir, "LAIre/raw_data/Global-0.5x0.5.analysis.",year,".nc",sep=""))
	data.meta.time <- length(ncvar_get(data.meta, "time"))
	
	data.name <- paste(data.rootdir,lainame,"/hantsout/smoothed/smoothed",year, sep="") 
	data = read.ENVI(data.name)
	if(year==year.min) {
		data.ly.name <- paste(data.rootdir,lainame,"/hantsout/smoothed/smoothed",year.min, sep="") 	
	}
	else {
		data.ly.name <- paste(data.rootdir,lainame,"/hantsout/smoothed/smoothed",year-1, sep="") 
	}
	data.ly = read.ENVI(data.name)
	
	if(year==year.max) {
		data.ny.name <- paste(data.rootdir,lainame,"/hantsout/smoothed/smoothed",year.max, sep="") 	
	}
	else {
		data.ny.name <- paste(data.rootdir,lainame,"/hantsout/smoothed/smoothed",year-1, sep="") 
	}
	data.ny = read.ENVI(data.name)
	
	data.max <- apply(data,c(1,2),max)
	data.min <- apply(data,c(1,2),min)
	data.delta <- data.max-data.min
	data.midpoint <- data.min + data.delta/2
	data.dims = dim(data)
	
	#data.aboveMP <- apply(data[73,378,], 3, function(x)  x > data.midpoint[73,378])
	#data.aboveMP = data[73,378,] > data.midpoint[73,378]
	#data.aboveMP
	
	data.out.sos <- array(data=NaN, dim=c(data.dims[1],data.dims[2]))
	data.out.eos <- array(data=NaN, dim=c(data.dims[1],data.dims[2]))
	
	#data.mask
	
	
	
	for(i in 1:data.dims[1]) {
		
		#if whole line is empty, go to next
		if(sum(data.mask[i,]) == 0){
			next()
		}
		for(j in 1:data.dims[2]) {
			if(data.mask[i,j] == 1) {
				#intra-annual variation too small
				if(data.delta[i,j]<0.5) {
					next()
				}
				val.act = data.midpoint[i,j]
				
				#simplified assumption: height of season in january-ish (southern hem)
				if(data[i,j,1]>data.midpoint[i,j]) {
					index.min.sos <- max(which(data[i,j,] <= val.act))
					index.min.eos <- min(which(data[i,j,] <= val.act))
				}
				else {
					index.min.sos <- min(which(data[i,j,] >= val.act))
					index.min.eos <- max(which(data[i,j,] >= val.act))
				}
				if(index.min.sos==1) {
					val.min.sos = data.ly[i,j,data.dims[3]]	
				}
				else {
					val.min.sos = data[i,j,index.min.sos-1]					
				}
				val.max.sos = data[i,j,index.min.sos]
			
				index.act = index.min.sos + (val.max.sos-val.act)/(val.max.sos-val.min.sos)
				data.out.sos[i,j] =  data.meta.time/data.dims[3]*index.act
			
			
				val.min.eos = data[i,j,index.min.eos]
				if(index.min.eos == data.dims[3]) {
					index.max.eos = data.ny[i,j,1]
				}
				else {
					val.max.eos = data[i,j,index.min.eos+1]
				}
				index.act = index.min.eos + (val.max.eos-val.act)/(val.max.eos-val.min.eos)
				data.out.eos[i,j] =  data.meta.time/data.dims[3]*index.act
			}
		}
	}
	
	write.ENVI(data.out.sos,paste(data.rootdir,lainame,"/LSPout/",year,"_sos",sep=""))
	write.ENVI(data.out.eos,paste(data.rootdir,lainame,"/LSPout/",year,"_eos",sep=""))
	rm(data.out.eos, data.out.sos, data.ny, data.ly, data.midpoint, data.meta)
}	
	
	#data.ts = ts(data.midpoint, start=c(year,1), frequency=24)
	#data.ts
	#write.ENVI(data.min,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_min",sep=""))
	#write.ENVI(data.max,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_max", sep=""))
	#write.ENVI(data.midpoint,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_midpoint", sep=""))
	#data[150:160,350:360,]

	#data.firstocc = apply(data[150:160,350:360,], c(1,2), function(x) match(x>data.midpoint, x))
	#data.firstocc
	#write.ENVI(data.firstocc, paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/", year, "_firstocc", sep="") )