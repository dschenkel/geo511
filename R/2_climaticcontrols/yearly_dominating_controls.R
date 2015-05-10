#
# yearly dominating facto

# 1 = temp
# 2 = moisture
# 3 = light



library(caTools)
library(raster)
source("../general_functions.R")


mtrx.dominating <- array(dim=c(360,720,30))
mtrx.changeflag <- array(dim=c(360,720))
print("go")
for (year in 1982:2011) {

	filename.mfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/MOIST_FAC/",year,"_MOIST_FAC", sep="") 
	filename.tfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/TEMP_FAC/",year,"_TEMP_FAC", sep="")
	filename.lfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/LIGHT_FAC/",year,"_LIGHT_FAC", sep="")

	mtrx.tfac.temp = read.ENVI(filename.tfac) 
	mtrx.mfac.temp = read.ENVI(filename.mfac) 
	mtrx.lfac.temp = read.ENVI(filename.lfac) 
	
	mtrx.tfac.sum <- apply(mtrx.tfac.temp,c(1,2),sum)
	mtrx.mfac.sum <- apply(mtrx.mfac.temp,c(1,2),sum)
	mtrx.lfac.sum <- apply(mtrx.lfac.temp,c(1,2),sum)

	mtrx.dominating.tmp = matrix(data=NA,nrow=360,ncol=720)
	mtrx.dominating.tmp[mtrx.lfac.sum>=mtrx.tfac.sum & mtrx.mfac.sum>=mtrx.tfac.sum] <- 1
	mtrx.dominating.tmp[mtrx.tfac.sum>=mtrx.mfac.sum & mtrx.lfac.sum>=mtrx.mfac.sum] <- 2
	mtrx.dominating.tmp[mtrx.mfac.sum>=mtrx.lfac.sum & mtrx.tfac.sum>=mtrx.lfac.sum] <- 3
	
	outname = paste("~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/",year,"_dominating_control",sep="")
	write.ENVI(mtrx.dominating.tmp, outname, interleave = "bsq" ) 

	mtrx.dominating[,,year-1981] = mtrx.dominating.tmp
	print(year)
}
print("finished_years")



