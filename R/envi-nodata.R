library(caTools)

year = 1983

filename = paste("~/Documents/Uni/Masterarbeit/LAIv3g/yearly/LAIv3g_",year, sep="") 

mtrx = read.ENVI(filename, headerfile=paste(filename, ".hdr", sep="")) 
mtrx[mtrx == 250] <-- NA

write.ENVI (mtrx, paste(filename,"_nodata", sep=""), interleave = "bsq" ) 
