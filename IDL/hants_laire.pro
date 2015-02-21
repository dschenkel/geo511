pro hants_laire

  inputdir  = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIre/yearly_envi/'
  outdir    = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIre/hantsout/'
  mask      = '/Users/davidschenkel/Documents/Uni/Masterarbeit/watermask/watermask.envi'

  for year=1982,2011 DO BEGIN
    
   filename   = inputdir + 'Global-0.5x0.5.analysis.' + STRTRIM(year,2) + '_rot.envi'
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
