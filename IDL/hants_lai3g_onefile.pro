pro hants_lai3g_onefile

  indir_nhem   = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/'
  ;indir_shem  =  '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/yearly/SHEM/'
  outdir_nhem  = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/hantsout/'
  ;outdir_shem = '/Users/davidschenkel/Documents/Uni/Masterarbeit/LAIv3g/hantsout/SHEM/'
  mask_nhem    = '/Users/davidschenkel/Documents/Uni/Masterarbeit/watermask/watermask.envi'
  ;mask_shem = '/Users/davidschenkel/Documents/Uni/Masterarbeit/watermask/watermask_shem.envi'

 ; for year=1993,1993 DO BEGIN

    filename   = indir_nhem + "LAIv3g_8211_INT_BSQ_resized"
    out_inter  = outdir_nhem + 'interp_LAIv3g_8211_INT_BSQ_resized'
    out_four   = outdir_nhem + 'fourier_LAIv3g_8211_INT_BSQ_resized'
    out_smooth = outdir_nhem + 'smoothed_LAIv3g_8211_INT_BSQ_resized'
    out_stat   = outdir_nhem + 'status_LAIv3g_8211_INT_BSQ_resized'


    cgi_hants, $
      fet = 7, $
      freqs = [0,24,48,72], $
      range = [-2,80], $
      tat = 10, $
      iMAX = 6, $
      data_if   = filename, $
      mask_if   = mask_nhem, $
      hants_of  = out_four, $
      status_of = out_stat, $
      smooth_of = out_smooth, $
      interp_of = out_inter



;  endfor
end