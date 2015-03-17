#library(fields)
library(caTools)
library(ncdf4)
#options(warn=2)
plotpixel <- function(ts, scene.sos, value.sos, scene.eos, value.eos) {

	# Graph cars using a y axis that ranges from 0 to 12
	plot(scene.sos, value.sos, col="blue", ylim=c(0,max(ts)), xlim=c(0,length(ts)))
	text(scene.sos+1, value.sos,"SOS")
	points(scene.eos,value.eos, col="green")
	text(scene.eos+1, value.eos,"EOS")
	# Graph trucks with red dashed line and square points
	lines(ts, type="o", col="red")
	
	legend(length(ts)-10, max((ts)), c("SOS","EOS"), cex=0.8, 
	   col=c("blue","green"));
}

hem = "NHEM"

data.rootdir = "~/Documents/Uni/Masterarbeit/"
data.mask <- read.ENVI(paste(data.rootdir,"watermask/watermask_",tolower(hem),".envi",sep=""))
lainame= "LAIv3g"
mindelta = 15
year.min = 1982
year.max = 1982



for(year in year.min:year.max) {
	data.meta <- nc_open(paste(data.rootdir, "LAIre/raw_data/Global-0.5x0.5.analysis.",year,".nc",sep=""))
	data.meta.time <- length(ncvar_get(data.meta, "time"))
	
	data.name <- paste(data.rootdir,lainame,"/hantsout/",hem,"/smoothed/smoothed",year, sep="") 
	data = read.ENVI(data.name)
	
	if(year==year.min) {
		data.ly.name <- paste(data.rootdir,lainame,"/hantsout/",hem,"/smoothed/smoothed",year.min, sep="") 	
	}
	else {
		data.ly.name <- paste(data.rootdir,lainame,"/hantsout/",hem,"/smoothed/smoothed",year-1, sep="") 
	}
	data.ly = read.ENVI(data.ly.name)
	
	if(year==year.max) {
		data.ny.name <- paste(data.rootdir,lainame,"/hantsout/",hem,"/smoothed/smoothed",year.max, sep="") 	
	}
	else {
		data.ny.name <- paste(data.rootdir,lainame,"/hantsout/",hem,"/smoothed/smoothed",year+1, sep="")
	}
	data.ny = read.ENVI(data.ny.name)
	
	data.max <- apply(data,c(1,2),max)
	data.min <- apply(data,c(1,2),min)
	data.delta <- data.max-data.min
	data.midpoint <- data.min + data.delta/2
	data.dims = dim(data)
	
	
	data.ly.max <- apply(data.ly,c(1,2),max)
	data.ly.min <- apply(data.ly,c(1,2),min)
	data.ly.delta <- data.ly.max-data.ly.min
	data.ly.midpoint <- data.ly.min + data.ly.delta/2
	
	
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
				if(data.delta[i,j] < mindelta) {
					next()
				}
	
				scenelength = data.meta.time/data.dims[3]
				
				#simplified assumption: height of season in january-ish (southern hem)
				if(data[i,j,1]>data.midpoint[i,j]) {
					val.act.sos = data.midpoint[i,j]
					val.act.eos = data.ly.midpoint[i,j]
					
					index.min.sos <- max(which(data[i,j,] <= val.act.sos))
					index.max.sos <- index.min.sos+1
					index.max.eos <- min(which(data[i,j,] <= val.act.eos))
					index.min.eos <- index.max.eos-1
					#print(index.min.sos)
				}
				else {
					val.act.sos = data.midpoint[i,j]
					val.act.eos = data.midpoint[i,j]
					
					index.max.sos <- min(which(data[i,j,] >= val.act.sos))
					index.min.sos <- index.max.sos-1
					index.min.eos <- max(which(data[i,j,] >= val.act.eos))
					index.max.eos <- index.min.eos+1
				}
				if(index.min.sos==0) {
					val.min.sos = data.ly[i,j,data.dims[3]]	
				}
				else {
					val.min.sos = data[i,j,index.min.sos]					
				}
				if(index.max.sos>data.dims[3]) {
					val.max.sos = data.ny[i,j,1]
				}
				else {
					val.max.sos = data[i,j,index.max.sos]					
				}
				#val.max.sos = data[i,j,index.max.sos]
								
				index.act.sos = index.min.sos + (val.act.sos-val.min.sos)/(val.max.sos-val.min.sos)
				data.out.sos[i,j] =  scenelength*index.act.sos-scenelength
			
			
				if(index.min.eos==0) {
					val.min.eos = data.ly[i,j,data.dims[3]]	
				}
				else {
					val.min.eos = data[i,j,index.min.eos]					
				}
				if(index.max.eos>data.dims[3]) {
					val.max.eos = data.ny[i,j,1]
				}
				else {
					val.max.eos = data[i,j,index.max.eos]					
				}
				index.act.eos = index.min.eos + (val.act.eos-val.min.eos)/(val.max.eos-val.min.eos) 
				data.out.eos[i,j] =  scenelength*index.act.eos-scenelength
				if(i == 99 && j == 201 && year == 1989) {
					print(val.act.sos)
					print(val.act.eos)
					
					print(data.out.sos[i,j])
					plotpixel(data[i,j,],index.act.sos,val.act.sos,index.act.eos,val.act.eos)
				}
				if(i == 231 && j == 420 && year == 1989) {
					print(val.act.sos)
					print(val.act.eos)
					
					#print(data.out.sos[i,j])
					plotpixel(data[i,j,],index.act.sos,val.act.sos,index.act.eos,val.act.eos)
				}
				
			}
		}
	}
	
	write.ENVI(data.out.sos,paste(data.rootdir,lainame,"/LSPout/",hem,"/MP/",lainame,"_",year,"_sos_MP",sep=""))
	write.ENVI(data.out.eos,paste(data.rootdir,lainame,"/LSPout/",hem,"/MP/",lainame,"_",year,"_eos_MP",sep=""))
	rm(data.out.eos, data.out.sos, data.ny, data.ly, data.midpoint, data.meta)
}	
warnings()
	#data.ts = ts(data.midpoint, start=c(year,1), frequency=24)
	#data.ts
	#write.ENVI(data.min,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_min",sep=""))
	#write.ENVI(data.max,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_max", sep=""))
	#write.ENVI(data.midpoint,paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/",year, "_midpoint", sep=""))
	#data[150:160,350:360,]

	#data.firstocc = apply(data[150:160,350:360,], c(1,2), function(x) match(x>data.midpoint, x))
	#data.firstocc
	#write.ENVI(data.firstocc, paste("~/Documents/Uni/Masterarbeit/LAIv3g/LSP_extract/", year, "_firstocc", sep="") )