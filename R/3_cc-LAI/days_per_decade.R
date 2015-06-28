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

library(caTools)
library(raster)
source("../general_functions.R")


for(prod in c("TEMP_FAC","MOIST_FAC","LIGHT_FAC")) {
	mtrx.sos.laire <- array(dim=c(360,720,30))
	mtrx.sos.lai3g <- array(dim=c(360,720,30))
	mtrx.eos.laire <- array(dim=c(360,720,30))
	mtrx.eos.lai3g <- array(dim=c(360,720,30))
	cat("go")
	for (year in 1982:2011) {
		filename.sos.lai3g = paste("/Users/davidschenkel/Documents/Uni/Masterarbeit/3_cc-LAI/LAI3g/monthly_",prod,"_at_SOS_",year, sep="") 
		filename.eos.lai3g = paste("/Users/davidschenkel/Documents/Uni/Masterarbeit/3_cc-LAI/LAI3g/monthly_",prod,"_at_EOS_",year, sep="") 
	
		filename.sos.laire = paste("/Users/davidschenkel/Documents/Uni/Masterarbeit/3_cc-LAI/LAIre/monthly_",prod,"_at_SOS_",year, sep="") 
		filename.eos.laire = paste("/Users/davidschenkel/Documents/Uni/Masterarbeit/3_cc-LAI/LAIre/monthly_",prod,"_at_EOS_",year, sep="")  

		mtrx.sos.laire[,,year-1981] = read.ENVI(filename.sos.laire, headerfile=paste(filename.sos.laire, ".hdr", sep="")) 
		mtrx.eos.laire[,,year-1981] = read.ENVI(filename.eos.laire, headerfile=paste(filename.eos.laire, ".hdr", sep="")) 
		mtrx.sos.lai3g[,,year-1981] = read.ENVI(filename.sos.lai3g, headerfile=paste(filename.sos.lai3g, ".hdr", sep="")) 
		mtrx.eos.lai3g[,,year-1981] = read.ENVI(filename.eos.lai3g, headerfile=paste(filename.eos.lai3g, ".hdr", sep="")) 
	}
	print(paste("finished_years",prod))
	
	out.sos.3g = days_per_decade(mtrx.sos.lai3g)
	outname.sos.3g = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/monthly_decadal_change/LAI3g_decadal_change_SOS_",prod,sep="")
	write.ENVI(out.sos.3g, outname.sos.3g, interleave = "bsq" ) 
	print(paste("lai3g SOS done",prod))
	
	out.eos.3g = days_per_decade(mtrx.eos.lai3g)
	outname.eos.3g = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/monthly_decadal_change/LAI3g_decadal_change_EOS_",prod,sep="")
	write.ENVI(out.eos.3g, outname.eos.3g, interleave = "bsq" ) 
	print(paste("lai3g EOS done",prod))
	
	out.sos.re = days_per_decade(mtrx.sos.laire)
	outname.sos.re = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/monthly_decadal_change/LAIre_decadal_change_SOS_",prod,sep="")
	write.ENVI(out.sos.re, outname.sos.re, interleave = "bsq" ) 
	print(paste("laire SOS done",prod))	
	
	out.eos.re = days_per_decade(mtrx.eos.laire)
	outname.eos.re = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/monthly_decadal_change/LAIre_decadal_change_EOS_",prod,sep="")
	write.ENVI(out.eos.re, outname.eos.re, interleave = "bsq" ) 
	print(paste("laire EOS done",prod))
}
