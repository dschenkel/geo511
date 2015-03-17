pro resize_laire
  ; Start ENVI
  e = ENVI()


  rootdir = "/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIre/"

 for year=1982,1982 DO BEGIN
   raster = e.OpenRaster(rootdir + "yearly_envi/Global-0.5x0.5.analysis." + STRTRIM(year,2) + "_rot.envi")
   Subset = ENVISubsetRaster(raster, BANDS=[0:14])
   fid = ENVIRasterToFID(Subset)
    tempout = e.GetTemporaryFilename()
   ; Compute statistics.
   ENVI_File_Query, fid, DIMS=dims, NB=nb
   ENVI_Doit, 'ENVI_Sum_Data_Doit', $
     DIMS = dims, $
     FID = fid, $
     POS = Lindgen(nb), $
     COMPUTE_FLAG = [0,0,1,0,0,0,0,0], $
     OUT_DT = 4, $
     OUT_BNAME = ['Mean'], $
     OUT_NAME = tempout
   
   
   
      for tstep=2,24 DO BEGIN
      
      firstscene = (tstep-1)*15
      lastscene = (tstep*15)-1
      Subset_new = ENVISubsetRaster(Raster, BANDS=[firstscene:lastscene])

      tempout_new = e.GetTemporaryFilename()
   ; Return a file ID
    fid_new = ENVIRasterToFID(Subset_new)

   ; Compute statistics.
     ENVI_File_Query, fid_new, DIMS=dims, NB=nb
     ENVI_Doit, 'ENVI_Sum_Data_Doit', $
     DIMS = dims, $
     FID = fid_new, $
     POS = Lindgen(nb), $
     COMPUTE_FLAG = [0,0,1,0,0,0,0,0], $
     OUT_DT = 4, $
     OUT_BNAME = ['Mean'], $
     OUT_NAME = tempout_new
     
     endfile = e.OpenRaster(tempout)
     addfile = e.OpenRaster(tempout_new)
     newout = ENVIMetaspectralRaster([endfile, addfile])
     file_delete, tempout
     file_delete, tempout_new
     tempout = e.GetTemporaryFilename()
     newout.Export, tempout ,"ENVI"
  endfor
  outfile = rootdir + "test1982"
  Subset.Export, outfile, "ENVI"
 endfor
end
