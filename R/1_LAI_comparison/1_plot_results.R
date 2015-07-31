source("quickplot.R")

#meth = "MI"
#plot bimonthly changes
for(meth in c("MP", "MI")) {
	for(prod in c("GSL", "EOS", "SOS")) {
		for(platf in c("LAI3g","LAIre")) {
		
			# decadal change
			filename = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/decade_change/",platf,"/",platf,"_changepdec_",prod,"_",meth,"",sep="")
			filename.out = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/decade_change/plots/",platf,"_changeperdec_",prod,"_",meth,".png",sep="")
			mtrx = read.ENVI(filename)
		
			classes.min = min(mtrx,na.rm=TRUE)
			classes.max = max(mtrx,na.rm=TRUE)
			classes.mid = 5.0
			#classes.bmid = -classes.mid+(classes.min+classes.mid)/2
			#classes.umid = classes.mid+(classes.max-classes.mid)/2
		
			#classes = c(classes.min,classes.bmid,-classes.mid,classes.mid,classes.umid,classes.max)
		
			#classes.names = c(paste(signif(classes.min,digits=3),"-",signif(classes.bmid,digits=3)),
			#paste(signif(classes.bmid,digits=3),"-",signif(-classes.mid,digits=3)),
			#paste(signif(-classes.mid,digits=3),"-",signif(classes.mid,digits=3)),
			#paste(signif(classes.mid,digits=3),"-",signif(classes.umid,digits=3)),
			#paste(signif(classes.umid,digits=3),"-",signif(classes.max,digits=3))
			#)
		
			classes = c(classes.min,-35,-25,-15,-5,5,15,25,35,classes.max)
			classes.names = c("<= -35 days", "-35 - -25 days", "-25 - -15 days", "-15 - -5 days", "-5 - 5 days", "5 - 15 days", "15 - 25 days", "25 - 35 days", ">= 35 days")
			colorPal=brewer.pal(9,"BrBG")
			quickplot(mtrx,classes=classes,color=colorPal,classes.names=classes.names, smoothing=FALSE, outname=filename.out)
			rm(classes, classes.names, mtrx, colorPal)
			
		

		}

		#plot difference maps
	
if(FALSE) {		for(year in c(1982:2011)) {
			
			filename = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/maps/",prod,"_diff/",meth,"/",year,"_LAIre-LAI3g_",prod,sep="")
			filename.out = paste("~/Documents/Uni/Masterarbeit/1_LAI_comparison/maps/plots/",prod,"_diff/",meth,"/",prod,"_diff_LAIre-LAI3g_",meth,"_",year,"_",meth,".png",sep="")
			mtrx = read.ENVI(filename)
	
			classes.min = min(mtrx,na.rm=TRUE)
			classes.max = max(mtrx,na.rm=TRUE)
			if(classes.min >= -180) {
				classes.min <- -181
			}
			if(classes.max <= 180) {
				classes.max <- 181
			}
		
			classes = c(classes.min,-180,-120,-60,-15,15,60,120,180,classes.max)
	
			classes.names = c("<= -180 days", 
								"-180 - -120 days", 
								"-120 - -60 days", 
								"-60 - -15 days", 
								"-15 - 15 days", 
								"15 - 60 days", 
								"60 - 120 days", 
								"120 - 180 days", 
								">= 180 days")
		
	
			colorPal=brewer.pal(9,"BrBG")
			quickplot(mtrx,classes=classes,color=colorPal,classes.names=classes.names, smoothing=FALSE, outname=filename.out)
	rm(classes, classes.names, mtrx, colorPal)
	
		}
						}

	}
}



