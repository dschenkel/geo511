library(caTools)
library(raster)


filename.waterm = "~/Documents/Uni/Masterarbeit/watermask/watermask.envi"
mtrx.mask = read.ENVI(filename.waterm)



for (year in 1982:2011) {
	
	filename.laire = paste("~/Documents/Uni/Masterarbeit/LAIre/bimonthly_means/LAIre_bimonthly_",year, sep="") 
	
	filename.lai3g = paste("~/Documents/Uni/Masterarbeit/LAIv3g/yearly/LAIv3g_",year,"_0.5", sep="") 

	filename.mask = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/yearly_strict/watermask_max_strict.",year,sep="")
	mtrx.mask = read.ENVI(filename.mask)

	mtrx.lai3g = read.ENVI(filename.lai3g, headerfile=paste(filename.lai3g, ".hdr", sep="")) 
	mtrx.lai3g[mtrx.mask == 0] <-- NA
	mtrx.lai3g = mtrx.lai3g/10
	
	mtrx.laire = read.ENVI(filename.laire, headerfile=paste(filename.laire, ".hdr", sep="")) 
	mtrx.lai3g.sum = apply(mtrx.lai3g,c(1,2),sum)
	mtrx.laire.sum = apply(mtrx.laire,c(1,2),sum)
	
	out = mtrx.laire.sum - mtrx.lai3g.sum
	
	out[mtrx.mask==NA] <-- NA
	outname = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/maps/yearly_diff/",year,"_summed_LAIre-LAI3g", sep="") 
	print(min(out/24,na.rm=TRUE))
	print(max(out/24,na.rm=TRUE))
	print(mean(out/24,na.rm=TRUE))
	
	write.ENVI(out, outname, interleave = "bsq" ) 
	
	rm(mtrx.lai3g, mtrx.laire, mtrx.lai3g.sum, mtrx.laire.sum, out)
	print(year)
	
}
