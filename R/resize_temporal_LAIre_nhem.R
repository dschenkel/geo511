library(caTools)
library(raster)
for (year in 2001:2011) {
	#filename = paste("~/Documents/Uni/Masterarbeit/LAIv3g/LAIv3g_8211_INT_BSQ", sep="") 
	#year = 1982
	filename = paste("~/Documents/Uni/Masterarbeit/LAIre/yearly_envi/Global-0.5x0.5.analysis.",year,"_rot.envi", sep="") 
	
	mtrx = read.ENVI(filename, headerfile=paste(filename, ".hdr", sep="")) 
	
	
	nhem_mask.name = paste("~/Documents/Uni/Masterarbeit/watermask/watermask_nhem.envi", sep="") 
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
	outlayer[0:180,,] <- rMean
	
	outname = paste("~/Documents/Uni/Masterarbeit/LAIre/bimonthly_means/NHEM/LAIre_nhem_bimonthly_",year, sep="") 
	write.ENVI(outlayer, outname, interleave = "bsq" ) 
	rm(mtrx, rMean, rS)
}
