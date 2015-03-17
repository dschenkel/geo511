library(caTools)
library(raster)
library(abind)
minyear = 1982
maxyear = 2011
for (year in 1994:2011) {
	#filename = paste("~/Documents/Uni/Masterarbeit/LAIv3g/LAIv3g_8211_INT_BSQ", sep="") 
	filename.first = paste("~/Documents/Uni/Masterarbeit/LAIre/yearly_envi/Global-0.5x0.5.analysis.",year,"_rot.envi", sep="") 
	
	mtrx.first = read.ENVI(filename.first, headerfile=paste(filename.first, ".hdr", sep="")) 

	filename.second = paste("~/Documents/Uni/Masterarbeit/LAIre/yearly_envi/Global-0.5x0.5.analysis.",year+1,"_rot.envi", sep="") 	
	if(year == maxyear) {
		filename.second = paste("~/Documents/Uni/Masterarbeit/LAIre/yearly_envi/Global-0.5x0.5.analysis.",year,"_rot.envi", sep="") 
	}
	
	mtrx.second = read.ENVI(filename.second, headerfile=paste(filename.second, ".hdr", sep="")) 
	
	mtrx = array(data=0, dim=c(180,720,365))


	mtrx = abind(mtrx.first[181:360,,183:365],mtrx.second[181:360,,1:182])
	#shem_mask.name = paste("~/Documents/Uni/Masterarbeit/watermask/watermask_shem.envi", sep="") 
	#nhem_mask = read.ENVI(nhem_mask.name, headerfile=paste(nhem_mask.name, ".hdr", sep="")) 
	
	#nhem_mask[nhem_mask == 0] <-- NA
	
	for( i in seq(360) ){
	    assign( paste0( "r" , i ) , raster( mtrx[0:180,,i] ) ) 
	}

	## Create a raster stack from these
	rS <- stack( mget( paste0("r",1:360) , envir = .GlobalEnv ) )	## Make 12 rasters, maybe one for each month of the year
	#rstrbrick
	rMean <- calc( rS , fun = function(x){ by(x , c( rep( 1:24 , each=15 ) ) , mean ) } )
	
	
	rMean = as.array(rMean)
	outlayer <- array(data=NA, dim=c(360,720,24))
	outlayer[181:360,,] <- rMean
	
	outname = paste("~/Documents/Uni/Masterarbeit/LAIre/bimonthly_means/SHEM/LAIre_shem_bimonthly_",year, sep="") 
	write.ENVI(outlayer, outname, interleave = "bsq" ) 
	rm(mtrx, rMean, rS, outlayer,mtrx.first,mtrx.second)
}
