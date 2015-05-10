rm(list = ls())

library(ncdf)
library(raster)
library(fields)
library(caTools)

month = list("01","02","03","04","05","06","07","08","09","10","11","12")
month.name = list("jan", "feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec")
#plt = array(0,dim=c(2160,4320,24))
#length(seq(-90,89.92,by=1/12))
#plt.lon <- seq(-90,89.92,by=1/12)
#plt.lat <- seq(-180,179.92,by=1/12)
#dimnames(plt) <- list(plt.lon,plt.lat,1:12)
for (year in 2010:2011) {
	mtrx.mask.year = matrix(1,nrow=360,ncol=720)
	mtrx.mask.nsyear = matrix(1,nrow=360,ncol=720)

	for (mon in 1:12) {
  	  file.name = paste("~/Documents/Uni/Masterarbeit/LAIv3g/raw_data/avhrrbulai_v01/AVHRRBUVI01.", year, month.name[mon], "a.abl", sep="") 
	  binread = readBin(con=file.name, what="integer", n=9331200, size=1, signed=F, endian="little")
	  # covert binary object into a matrix using specifications from the metadata
	  mtrx = matrix(binread, nrow=2160, ncol=4320, byrow=F)
	  mtrx.mask.month = matrix(1,nrow=360,ncol=720)
	  for(i in seq(from=1, to=2160, by=6)) {
		  for(j in seq(from=1, to=4320, by=6)) {
			  imax = i+5
			  jmax = j+5
			  	if(max(mtrx[i:imax,j:jmax])==250) {
					inew = imax/6
					jnew = jmax/6
					#mtrx.mask.month[inew,jnew] = NA
					mtrx.mask.year[inew,jnew] = NA
					if(sum(mtrx[i:imax,j:jmax]==250)>18) {
						mtrx.mask.nsyear[inew,jnew] = NA
					}
				}
			}
		}
		#outname.month = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/monthly/watermask.", year, month.name[mon], "a", sep="")
		#write.ENVI(mtrx.mask.month, outname.month, interleave = "bsq" ) 
		
    	  file.name = paste("~/Documents/Uni/Masterarbeit/LAIv3g/raw_data/avhrrbulai_v01/AVHRRBUVI01.", year, month.name[mon], "b.abl", sep="") 
  	  binread = readBin(con=file.name, what="integer", n=9331200, size=1, signed=F, endian="little")
  	  # covert binary object into a matrix using specifications from the metadata
  	  mtrx = matrix(binread, nrow=2160, ncol=4320, byrow=F)
  	  mtrx.mask.month = matrix(1,nrow=360,ncol=720)
  	  for(i in seq(from=1, to=2160, by=6)) {
  		  for(j in seq(from=1, to=4320, by=6)) {
  			  imax = i+5
  			  jmax = j+5
  			  	if(mean(mtrx[i:imax,j:jmax])==250) {
  					inew = imax/6
  					jnew = jmax/6
  					#mtrx.mask.month[inew,jnew] = NA
  					mtrx.mask.year[inew,jnew] = NA
					if(sum(mtrx[i:imax,j:jmax]==250)>18) {
						mtrx.mask.nsyear[inew,jnew] = NA
					}
  				}
  			}
  		}
  		#outname.month = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/monthly/watermask.", year, month.name[mon], "b", sep="")
  		#write.ENVI(mtrx.mask.month, outname.month, interleave = "bsq" ) 
	}
	outname = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/yearly_strict/watermask_max_strict.", year, sep="")
	write.ENVI(mtrx.mask.year, outname, interleave = "bsq" ) 
	
	outname = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/yearly_semistrict/watermask_max_semistrict.", year, sep="")
	write.ENVI(mtrx.mask.nsyear, outname, interleave = "bsq" ) 
	
}
# multiplication by 0.1 for LAI and 0.01 for FAPAR sets the actual value
#mtrx = mtrx*0.1
#dimnames(plt) <- list(-180:180,d.lat,d.time)
#plt[,,2*i-1] = mtrx
#abind(frm,mtrx,rev.along=0)  