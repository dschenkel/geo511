library(ncdf4)
library(raster)
library(fields)
library(caTools)


for(prod in c("LIGHT_FAC")) {
	for(year in 1982:2011){
		rootdir = paste("~/Documents/Uni/Masterarbeit/",sep="")
		# ??open.ncdf
		filename <- paste(rootdir,"LAIre/raw_data/Global-0.5x0.5.analysis.",year,".nc",sep="")
		nc <- nc_open(filename)

		mtrx <- ncvar_get(nc, prod)
		
		
		for( i in 3:362 ){
			mtrx.temp = mtrx[,,i]
			d <- raster( mtrx.temp )
			d <-  flip(t(d), direction = "y")
		    assign( paste0( "r" , i ) , d ) 
		}

		## Create a raster stack from these
		rS <- stack( mget( paste0("r",3:362) , envir = .GlobalEnv ) )	## Make 12 rasters, maybe one for each month of the year
		#rstrbrick
		rMean <- calc( rS , fun = function(x){ by(x , c( rep( 1:24 , each=15 ) ) , mean ) } )
	
	
		rMean = as.array(rMean)
	
		write.ENVI(rMean, paste(rootdir,"climatic_controls/",prod,"/",year,"_",prod, sep=""), interleave = "bsq" ) 

		rm(mtrx, rMean, rS, nc)
		print(year)
	}
}