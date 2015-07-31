#
# yearly dominating facto

# 1 = temp
# 2 = moisture
# 3 = light



library(caTools)
library(raster)
library(RColorBrewer)
source("quickplot.R")
#install.packages("maptools")
#mtrx.dominating <- array(dim=c(360,720,30))
#mtrx.changeflag <- array(dim=c(360,720))
print("go")
for (year in 1982:2011) {

	filename.mfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/MOIST_FAC/",year,"_MOIST_FAC", sep="") 
	filename.tfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/TEMP_FAC/",year,"_TEMP_FAC", sep="") 
	filename.lfac = paste("~/Documents/Uni/Masterarbeit/climatic_controls/LIGHT_FAC/",year,"_LIGHT_FAC", sep="")  

	mtrx.tfac.sum = read.ENVI(filename.tfac)
	mtrx.mfac.sum = read.ENVI(filename.mfac)
	mtrx.lfac.sum = read.ENVI(filename.lfac)

	mtrx.tfac.sum = apply(mtrx.tfac.sum,c(1,2),sum)
	mtrx.mfac.sum = apply(mtrx.mfac.sum,c(1,2),sum)
	mtrx.lfac.sum = apply(mtrx.lfac.sum,c(1,2),sum)


	mtrx.dominating.tmp = matrix(data=NA,nrow=360,ncol=720)


	mtrx.dominating.tmp[mtrx.lfac.sum>=mtrx.tfac.sum & mtrx.mfac.sum>=mtrx.tfac.sum] <- 1
	mtrx.dominating.tmp[mtrx.tfac.sum>=mtrx.mfac.sum & mtrx.lfac.sum>=mtrx.mfac.sum] <- 2
	mtrx.dominating.tmp[mtrx.mfac.sum>=mtrx.lfac.sum & mtrx.tfac.sum>=mtrx.lfac.sum] <- 3

	outname = paste("~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/new_meth/dominating_control_",year,sep="")
	write.ENVI(mtrx.dominating.tmp, outname, interleave = "bsq" ) 
	#mtrx.dominating[,,year-1981] = mtrx.dominating.tmp
	colorPal=brewer.pal(3,"Accent")
	quickplot(mtrx.dominating.tmp,classes=3, classes.name=c("temp", "moist", "light"), colors=colorPal,smoothing=FALSE,outname=paste("/Users/davidschenkel/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/new_meth/plot_dominating_",year,sep=""))
	
	print(year)
}

print("finished_years")



