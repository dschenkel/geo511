library(caTools)
library(raster)
library(stats)
source("general_functions.R")

strict = "strict"


#month.name = list("jan", "feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec")
month.name = list("jana", "janb", "feba","febb","mara","marb","apra","aprb", "maya","mayb","juna","junb","jula","julb","auga","augb","sepa","sepb","octa","octb","nova","novb","deca","decb")
#plt = array(0,dim=c(2160,4320,24))
#length(seq(-90,89.92,by=1/12))
#plt.lon <- seq(-90,89.92,by=1/12)
#plt.lat <- seq(-180,179.92,by=1/12)
#dimnames(plt) <- list(plt.lon,plt.lat,1:12)
table = matrix(data = NA, nrow = 720, ncol = 4)
full.laire = numeric(0)
full.lai3g = numeric(0)
counter = 1
for (year in 1982:2011) {
	filename.laire = paste("~/Documents/Uni/Masterarbeit/LAIre/bimonthly_means/LAIre_bimonthly_",year, sep="") 
	filename.lai3g = paste("~/Documents/Uni/Masterarbeit/LAIv3g/yearly/LAIv3g_",year,"_0.5", sep="") 	
	mtrx.laire = read.ENVI(filename.laire, headerfile=paste(filename.laire, ".hdr", sep=""))
	mtrx.lai3g = read.ENVI(filename.lai3g, headerfile=paste(filename.lai3g, ".hdr", sep=""))

	for (i in 1:24) {
		
	 	filename.mask = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/monthly/watermask.",year,month.name[i],sep="")
		mtrx.mask = read.ENVI(filename.mask)
		mtrx.laire.cur = mtrx.laire[,,i]
		mtrx.lai3g.cur = mtrx.lai3g[,,i]
		mtrx.lai3g.cur = mtrx.lai3g.cur/10
		
		mtrx.lai3g.cur[mtrx.mask==NA] <-- NA
		mtrx.laire.cur[mtrx.mask==NA] <-- NA
		
		laire = as.vector(mtrx.laire.cur)
		lai3g = as.vector(mtrx.lai3g.cur)
		full.laire = append(full.laire,laire)
		full.lai3g = append(full.lai3g,lai3g)
		entryname = paste(year,"_",month.name[i],sep="")
		stat = cor.test(laire, lai3g,method="pearson",use="pairwise.complete.obs")
		#rbind(table,c(entryname,stat$estimate,stat$p.value))
		table[counter,1] = entryname
		table[counter,2] = stat$estimate #cor(laire, lai3g,method="spearman",use="pairwise.complete.obs")
		table[counter,3] = stat$p.value
		table[counter,4] = cov(laire,lai3g)
		counter = counter + 1
	 	#filename.mask = paste("~/Documents/Uni/Masterarbeit/watermask/lai3g/monthly/watermask.",year,month.name[i],"b",sep="")
		#mtrx.mask = read.ENVI(filename.mask)
		#mtrx.laire.cur = mtrx.laire[,,2*i]
		#mtrx.lai3g.cur = mtrx.lai3g[,,2*i]
		#mtrx.lai3g.cur = mtrx.lai3g.cur/10
		
		#mtrx.lai3g.cur[mtrx.mask==NA] <-- NA
		#mtrx.laire.cur[mtrx.mask==NA] <-- NA
		
		#laire = as.vector(mtrx.laire.cur)
		#lai3g = as.vector(mtrx.lai3g.cur)
		
		#entryname = paste(year,"_",month.name[i],"b",sep="")
		#stat = cor.test(laire, lai3g,method="pearson",use="pairwise.complete.obs")
		#test = cor.test(laire, lai3g,method="pearson",use="pairwise.complete.obs")
		#rbind(table,c(entryname,stat$estimate,stat$p.value))
		
		#table[entryname,1] = stat$estimate #cor(laire, lai3g,method="spearman",use="pairwise.complete.obs")
		#table[entryname,2] = stat$p.value
	}
		print(year)
}
#table["all"] = cor(full.laire, full.lai3g, method="spearman", use="pairwise.complete.obs")
print(table)
write.csv(table, file = "~/Documents/Uni/Masterarbeit/1_LAI_comparison/bimonthly_raw_corr_cov.csv")
