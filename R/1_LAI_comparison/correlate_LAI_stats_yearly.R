library(caTools)
library(raster)
library(stats)
source("../general_functions.R")

strict = "strict"


out = matrix(nrow=30,ncol=3,dimnames=list(1982:2011,c("max","mean","min")))

for (year in 1982:2011) {
#	year=1982
	filename.mask = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/yearly_",strict,"/watermask_max_",strict,".",year,sep="")
	mtrx.mask = read.ENVI(filename.mask)
	
	filename.laire = paste("~/Documents/Uni/Masterarbeit/LAIre/bimonthly_means/LAIre_bimonthly_",year, sep="") 
	filename.lai3g = paste("~/Documents/Uni/Masterarbeit/LAIv3g/yearly/LAIv3g_",year,"_0.5", sep="") 

	mtrx.laire = read.ENVI(filename.laire, headerfile=paste(filename.laire, ".hdr", sep=""))
	mtrx.lai3g = read.ENVI(filename.lai3g, headerfile=paste(filename.lai3g, ".hdr", sep=""))
	
	mtrx.lai3g = mtrx.lai3g/10
	
	data.mean.laire <- apply(mtrx.laire,c(1,2),mean)
	data.mean.lai3g <- apply(mtrx.lai3g,c(1,2),mean)
	data.max.laire <- apply(mtrx.laire,c(1,2),max)
	data.max.lai3g <- apply(mtrx.lai3g,c(1,2),max)
	data.min.laire <- apply(mtrx.laire,c(1,2),min)
	data.min.lai3g <- apply(mtrx.lai3g,c(1,2),min)

	#mtrx.laire.stats = getStats(mtrx.laire)
	#mtrx.lai3g.stats = getStats(mtrx.lai3g/10)
	#max.stack = stack(mtrx.laire.stats[1],mtrx.lai3g.stats[1])
	#max.corr = layerStats(max.stack,'pearson', na.rm=TRUE)
	#lm.out = lm((data.max.laire) - (data.max.lai3g))
	#lm.out
	#summary(lm.out)
	#out[year-1981,1] =  cor(as.vector(data.max.laire),as.vector(data.max.lai3g),method="spearman",use="pairwise.complete.obs")
	#max.corr
	#out[year-1981,2] =  cor(as.vector(data.mean.laire),as.vector(data.mean.lai3g),method="spearman",use="pairwise.complete.obs")
	#mean.corr
	#out[year-1981,3]  = cor(as.vector(data.min.laire),as.vector(data.min.lai3g),method="spearman",use="pairwise.complete.obs")
	#min.corr
#	out

	namelist = list("map1" = "LAI3g", "map2" = "LAIre", 
		"outdir" = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/statistics/raw_lai/",sep=""))
	namelist["statfile"] = paste("statistics_",year,"_max",sep="")
	namelist["title"] = "Linear Regression: LAI3g_max - LAIre_max"
	correlate_2d(data.max.lai3g,data.max.laire,namelist,mtrx.mask)

	namelist["statfile"] = paste("statistics_",year,"_min",sep="")
	namelist["title"] = "Linear Regression: LAI3g_min - LAIre_min"
	correlate_2d(data.min.lai3g,data.min.laire,namelist,mtrx.mask)

	namelist["statfile"] = paste("statistics_",year,"mean",sep="")
	namelist["title"] = "Linear Regression: LAI3g_mean - LAIre$
	_mean"
	correlate_2d(data.mean.lai3g,data.mean.laire,namelist,mtrx.mask)
	#write.ENVI(mtrx.diff.sos, outname.sosdiff, interleave = "bsq" ) 
	#write.ENVI(mtrx.diff.gsl, outname.gsldiff, interleave = "bsq" ) 
	#rm(mtrx.laire, mtrx.lai3g)
	print(year)
}
#write.csv(out, file = "~/Documents/Uni/Masterarbeit/1_LAI_comparison/max_mean_min_corr.csv")
