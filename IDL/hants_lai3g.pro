pro hants_lai3g

  indir   = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/yearly/'
  outdir  = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/hantsout/'
  mask    = '/Users/davidschenkel/Documents/Uni/Masterarbeit/watermask/watermask.envi'

  for year=1989,1990 DO BEGIN
    
   filename   = indir + "LAIv3g_" + STRTRIM(year,2) + '_0.5'
   out_inter  = outdir + 'inter/inter' + STRTRIM(year,2)
   out_four   = outdir + 'fourier/fourier' + STRTRIM(year,2)
   out_smooth = outdir + 'smoothed/smoothed' + STRTRIM(year,2)
   out_stat   = outdir + 'status/status' + STRTRIM(year,2)


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
    smooth_of = out_smooth, $
    interp_of = out_inter
    
  endfor
end
