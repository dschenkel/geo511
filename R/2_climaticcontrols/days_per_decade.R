#
# bimonthly maps of changes (if any?) of climatic control strength

library(caTools)
library(raster)
source("../general_functions.R")


mtrx.tfac <- array(dim=c(360,720,30,24))
mtrx.mfac <- array(dim=c(360,720,30,24))
cat("go")
for (year in 1982:2011) {
	filename.tfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/MOIST_FAC/",year,"_MOIST_FAC", sep="") 
	filename.mfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/TEMP_FAC/",year,"_TEMP_FAC", sep="")

	mtrx.tfac.temp = read.ENVI(filename.tfac) 
	mtrx.mfac.temp = read.ENVI(filename.mfac) 
	
	mtrx.tfac[,,year-1981,] = mtrx.tfac.temp
	mtrx.mfac[,,year-1981,] = mtrx.mfac.temp
}
print("finished_years")

plot(1982:2011,mtrx.tfac[152,439,,4])

for(i in 1:24) {
	out.tfac = days_per_decade(mtrx.tfac[,,,i])
	outname.tfac = paste("~/Documents/Uni/Masterarbeit/2_controls/bimonthly_changes/TEMP_FAC_",ifelse(10>=i,"","0"),i,sep="")
	write.ENVI(out.tfac, outname.tfac, interleave = "bsq" ) 

	out.mfac = days_per_decade(mtrx.mfac[,,,i])
	outname.mfac = paste("~/Documents/Uni/Masterarbeit/2_controls/bimonthly_changes/MOIST_FAC_",ifelse(10>=i,"","0"),i,sep="")
	write.ENVI(out.mfac, outname.mfac, interleave = "bsq" ) 
	print(i)
}


