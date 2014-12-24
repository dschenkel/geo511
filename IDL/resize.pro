pro resize
  e = ENVI()

  ; Open a file
  rootdir = "/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/yearly/"
  ;file1 = FILEPATH("Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/LAIv3g_8211_INT_BSQ_resized", ROOT_DIR="/" )
  ;file = DIALOG_PICKFILE(/READ)
  ;print,file

  ; Create a spatial subset of 100 samples x 100 lines
  ; and a spectral subset of Band 1.
  for year=1984,2011 DO BEGIN

    raster = e.OpenRaster(rootdir + "LAIv3g_" + STRTRIM(year,2) + "_nodata")
    NewRaster = raster.Resize(Raster, DIMENSIONS=[720,360], METHOD='Bilinear')

    outfile = rootdir + "LAIv3g_" + STRTRIM(year, 2) + "_0.5"
    print,outfile
    NewRaster.Export, outfile, 'ENVI'
  endfor
 
 end