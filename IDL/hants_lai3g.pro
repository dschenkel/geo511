pro hants_lai3g

  inputdir  = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/yearly/'
  outdir    = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/hantsout/'
  mask      = '/Users/davidschenkel/Documents/Uni/Masterarbeit/watermask/watermask.envi'

  for year=1982,2011 DO BEGIN
    
   filename       = inputdir + "LAIv3g_" + STRTRIM(year,2) + '_0.5'
   output_inter   = folder_output + 'inter/inter' + STRTRIM(year,2)
   out_four       = folder_output + 'fourier/fourier' + STRTRIM(year,2)
   output_smooth  = folder_output + 'smoothed/smoothed' + STRTRIM(year,2)
   out_stat       = folder_output + 'status/status' + STRTRIM(year,2)


   cgi_hants, $
    fet = 1, $
    freqs = [0,1,2,3], $
    range = [-2,8], $
    tat = 10, $
    iMAX = 6, $
    data_if   = filename, $
    mask_if   = mask, $
    hants_of  = out_four, $
    status_of = out_stat, $
    smooth_of = output_smooth, $
    interp_of = output_inter
    
  endfor
end
