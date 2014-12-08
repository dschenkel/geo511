#########################################################################################
# This code ingests binary GIMMS FAPAR and LAI data and converts them to GeoTIFFs. 
# The data was produced by the Climate and Vegetation Research Group of Boston University. 
# The GIMMS data are available from: http://cliveg.bu.edu/modismisr/lai3g-fpar3g.html
 
# title         : GIMMS3g_LAI_FPAR_Binary2Geotiff.r
# purpose       : Converts binary GIMMS FAPAR/LAI to GeoTIFFs
# author        : Abdulhakim Abdi
# input         : Binary 8-bit unsigned integer with ieee-be byte order
# output        : Georeferenced TIFF, ArcGIS-ready files
 
#########################################################################################
 
# install the necessary packages if you don't already have them
install.packages(c("rgdal", "sp", "raster"), repos='http://cran.r-project.org')
install.packages("rgdal")
# load required libraries and set working directory
library(sp, rgdal, raster)
 
# specify temporal parameters
year = 1982:2011
month = list("01","02","03","04","05","06","07","08","09","10","11","12")
month.name = list("jan", "feb","mar","apr","may","jun","jul","aug",
              "sep","oct","nov","dec")
 
# set to loop through years and months within each year
for (i in 1:length(1982:2011)){
  year
  for (j in 1:12){
    month
 
    ### process "a"-lettered files
        letter = 'a'
 
    # set name format and read binary file
    file.name = paste("J:/GIMMS/avhrrbulai_v01/AVHRRBUVI01.",year[i],
                      month.name[j], letter, '.abl', sep="")
    binread = readBin(con=file.name, what="integer", n=9331200, size=1, signed=F, endian="little")
 
    # covert binary object into a matrix using specifications from the metadata
    mtrx = matrix(binread, nrow=2160, ncol=4320, byrow=F)
 
    # convert to matrix to a raster object
    rstr = raster(mtrx)
 
    # specify extent and projection
    extent(rstr) < - extent(c(-180, 180, -90, 90))
    projection(rstr) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
 
    # set NA values (according to the metadata n=250 is a NULL value)
    rstr[rstr == 250] <-- NA
 
    # multiplication by 0.1 for LAI and 0.01 for FAPAR sets the actual value
    rstr = rstr*0.1
    rstr.name = paste("LAI", "_", year[i], "_", month[j], "_", letter, sep="")
 
    # write to file
    writeRaster(rstr, filename=paste("J:/GIMMS/avhrrbulai_v01_Gtiffs_TEST/",rstr.name,".tif", sep=""), 
	format="GTiff", overwrite=TRUE)
 
    # free memory
    rm(letter,file.name,mtrx,rstr,rstr.name)
 
    ### process "b"-lettered files
        letter = 'b'
 
    # set name format and read binary file
    file.name = paste("J:/GIMMS/avhrrbulai_v01/AVHRRBUVI01.",year[i],
                      month.name[j], letter, '.abl', sep="")
 
    binread = readBin(con=file.name, what="integer", n=9331200, size=1, signed=F, endian="little")
 
    # covert binary object into a matrix using specifications from the metadata
    mtrx = matrix(binread, nrow=2160, ncol=4320, byrow=F)
 
    # convert to matrix to a raster object
    rstr = raster(mtrx)
 
    # specify extent and projection
    extent(rstr) <- extent(c(-180, 180, -90, 90))
    projection(rstr) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
 
    # set NA values (according to the metadata n=250 is a NULL value)
    rstr[rstr == 250] <-- NA
 
    # multiplication by 0.1 for LAI and 0.01 for FAPAR sets the actual value
    rstr = rstr*0.1
    rstr.name = paste("LAI", "_", year[i], "_", month[j], "_", letter, sep="")
 
    # write to file
    writeRaster(rstr, filename=paste("J:/GIMMS/avhrrbulai_v01_Gtiffs_TEST/",rstr.name,".tif", sep=""), 
	format="GTiff", overwrite=TRUE)
 
    # free memory
    rm(letter,file.name,mtrx,rstr,rstr.name)
 
  }
}
 
# clear memory
rm(list=ls())
 
# End of script