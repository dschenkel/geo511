library(sp)
library(raster)
library(fields)
library(rgdal)
library(ncdf)

month <- c("jana","janb","feba","febc","mara","marb","apra","aprb","maya","mayb","juna","junb","jula","julb","auga","augb","sepa","sepb","octa","octb","nova","novb","deca","decb")



file.name = paste("~/Documents/Uni/Masterarbeit/LAIre/Global-0.5x0.5.analysis.1985.nc", sep="") 
file <- open.ncdf(file.name)
file.lai <- get.var.ncdf(file, "LAI")
is.array(file.lai)
t <- length(get.var.ncdf(file,"time"))

if(length(t) < 366){
	month.ndays <- c(15,16,14,14,15,16,15,15,15,16,15,15,15,16,15,16,15,15,15,16,15,15,15,16)
	} else {
	month.ndays <- c(15,16,14,15,15,16,15,15,15,16,15,15,15,16,15,16,15,15,15,16,15,15,15,16)
}
	
y <- factor(rep(month, month.ndays))

aggregate(file.lai,by = as.list(y), FUN = sum )

for (year in 1982:2011) {
	for (i in 1:24) {
	  #bimonthly
  
	  file.name = paste("~/Documents/Uni/Masterarbeit/LAIre/Global-0.5x0.5.analysis.", year, ".nc", sep="") 
	  file <- open.ncdf(file.name)
	  file.lai <- get.var.ncdf(file, "LAI")
  	  file

	  #plot(rstr)
	  rm(file.name,mtrx, rstr.new, rstr)
	  gc()
	}
}
#plt.max <- apply(plt,c(1,2),max)
#plt.max <- t(plt.max)
#image.plot(1:2160, 1:4320, plt.max)
#which.max( apply( plt , 3 , max ) )

#plt[450,2500,]
#plot(1:24, plt[450,2500,])
?rep