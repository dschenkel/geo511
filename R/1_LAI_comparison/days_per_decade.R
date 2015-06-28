#
# 1 SOS_mean
# 2 SOS_absChange
# 3 SOS_pvalue
# 4 EOS_mean
# 5 EOS_absChange
# 6 EOS_pvalue
# 7 LGS_mean
# ...
#

param = 7
param.name = "GSL"

library(caTools)
library(raster)
source("../general_functions.R")


for (meth in c("MP", "MI")) {
	mtrx.laire <- array(dim=c(360,720,30))
	mtrx.lai3g <- array(dim=c(360,720,30))
	cat("go")
	for (year in 1982:2011) {
		filename.shem.laire = paste("~/Documents/Uni/Masterarbeit/LAIre/VIprocessor_output/SHEM/PHENO/",year,"_SHEM_",meth,"__PHENO", sep="") 
		filename.nhem.laire = paste("~/Documents/Uni/Masterarbeit/LAIre/VIprocessor_output/NHEM/PHENO/",year,"_NHEM_",meth,"__PHENO", sep="") 
	
		filename.shem.lai3g = paste("~/Documents/Uni/Masterarbeit/LAIv3g/VIprocessor_output/SHEM/PHENO/LAI3g_",year,"_SHEM_",meth,"__PHENO", sep="") 
		filename.nhem.lai3g = paste("~/Documents/Uni/Masterarbeit/LAIv3g/VIprocessor_output/NHEM/PHENO/LAI3g_",year,"_NHEM_",meth,"__PHENO", sep="") 

		mtrx.shem.laire = read.ENVI(paste(filename.shem.laire,".bsq",sep=""), headerfile=paste(filename.shem.laire, ".hdr", sep="")) 
		mtrx.nhem.laire = read.ENVI(paste(filename.nhem.laire,".bsq",sep=""), headerfile=paste(filename.nhem.laire, ".hdr", sep="")) 
		mtrx.shem.lai3g = read.ENVI(paste(filename.shem.lai3g,".bsq",sep=""), headerfile=paste(filename.shem.lai3g, ".hdr", sep="")) 
		mtrx.nhem.lai3g = read.ENVI(paste(filename.nhem.lai3g,".bsq",sep=""), headerfile=paste(filename.nhem.lai3g, ".hdr", sep="")) 


		mtrx.laire[181:360,,year-1981] <- mtrx.shem.laire[181:360,,param] 
		mtrx.laire[1:180,,year-1981] <- mtrx.nhem.laire[1:180,,param]

		mtrx.lai3g[181:360,,year-1981] <- mtrx.shem.lai3g[181:360,,param] 
		mtrx.lai3g[1:180,,year-1981] <- mtrx.nhem.lai3g[1:180,,param]
	
	}
	print("finished_years")
	out.3g = days_per_decade(mtrx.lai3g)
	outname.3g = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/decade_change/LAI3g/LAI3g_changepdec_",param.name,"_",meth,sep="")
	write.ENVI(out.3g, outname.3g, interleave = "bsq" ) 
	print("lai3g done")
	out.re = days_per_decade(mtrx.laire)
	outname.re = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/decade_change/LAIre/LAIre_changepdec_",param.name,"_",meth,sep="")
	write.ENVI(out.re, outname.re, interleave = "bsq" ) 
	
	print("laire done")
	
}
