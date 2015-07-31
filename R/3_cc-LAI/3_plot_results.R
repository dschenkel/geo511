source("../quickplot.R")

for(phenop in c("SOS","EOS")) {
	for(prod in c("LAIre","LAI3g")) {
		for (year in 1982:2011) {
			filename = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/yearly_dominating/",prod,"/",phenop,"_dominating_control_",year,sep="")
			mtrx = read.ENVI(filename)
			classes=c(0.5,1.5,2.5,3.5)
			classes.names = c("Temperature","Moisture","Radiation")
			colorPal=brewer.pal(3,"Pastel1")
			filename.out = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/yearly_dominating/plots/",prod,"/",phenop,"_dominating_control_",year,".png",sep="")
			quickplot(mtrx,classes=classes,color=colorPal,classes.names=classes.names, smoothing=FALSE, outname=filename.out)
			
		}
		#maskname = "~/Documents/Uni/Masterarbeit/watermask/watermask.envi"
		#mtrx.mask = read.ENVI(maskname)
		filename.uchanges = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/yearly_dominating/",phenop,"_",prod,"_unique_dominating_factors",sep="")
		mtrx = read.ENVI(filename.uchanges) 
		classes = c(0.5,1.5,2.5,3.5)
		classes.names = c("no change in domniating control", "change between 2 controls", "change between 3 controls")
		colorPal = brewer.pal(3,"Pastel1")
		colorPal[1] = "#FFFFFF"
		quickplot(mtrx,classes=classes,classes.names=classes.names,colors=colorPal,outname=paste(filename.uchanges,".png",sep=""))
	}
}


#plot bimonthly decadal changes
for(prod in c("MOIST_FAC","TEMP_FAC","LIGHT_FAC")) {
	for(pheno in c("EOS","SOS")) {
		for(platf in c("LAIre","LAI3g")) {
			filename = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/monthly_annual_change_signf/",platf,"_annual_change_",pheno,"_",prod,sep="")
			filename.out = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/monthly_annual_change_signf/plots/",platf,"_annual_change_",pheno,"_",prod,".png",sep="")
			mtrx = read.ENVI(filename)
		
			#classes.min = min(mtrx,na.rm=TRUE)
			#classes.max = max(mtrx,na.rm=TRUE)
			#classes.mid = 0.03
			#classes.bmid = -classes.mid+(classes.min+classes.mid)/2
			#classes.umid = classes.mid+(classes.max-classes.mid)/2
		
			#classes = c(classes.min,classes.bmid,-classes.mid,classes.mid,classes.umid,classes.max)
		
			#classes.names = c(paste(signif(classes.min,digits=3),"-",signif(classes.bmid,digits=3)),
			#paste(signif(classes.bmid,digits=3),"-",signif(-classes.mid,digits=3)),
			#paste(signif(-classes.mid,digits=3),"-",signif(classes.mid,digits=3)),
			#paste(signif(classes.mid,digits=3),"-",signif(classes.umid,digits=3)),
			#paste(signif(classes.umid,digits=3),"-",signif(classes.max,digits=3))
			#)
			
			classes = classify_image.div(mtrx,7,0.1)

			classes.names = name_classes(classes)

			colorPal=brewer.pal(7,"BrBG")
			quickplot(mtrx,classes=classes,color=colorPal,classes.names=classes.names, smoothing=FALSE, outname=filename.out)
		
		}
	}
}




#source("../quickplot.R")


# yearly dominating controls
for(year in 1982:2011) {
	for(plat in c("LAIre","LAI3g")) {
		for(pheno in c("SOS","EOS")) {
			
			filename = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/yearly_dominating/",plat,"/",pheno,"_dominating_control_",year,sep="")
			filename.out = paste("~/Documents/Uni/Masterarbeit/3_cc-LAI/yearly_dominating/plots/",plat,"/",pheno,"_dominating_control_",year,".png",sep="")
			mtrx = read.ENVI(filename)
	
			classes=c(0.5,1.5,2.5,3.5)
			classes.names = c("Temperature","Moisture","Radiation")
			colorPal=brewer.pal(3,"Pastel1")
			quickplot(mtrx,classes=classes,color=colorPal,classes.names=classes.names, smoothing=FALSE, outname=filename.out)
	
			
			
		}
	}

}
#filename = "~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/1982_dominating_control"
#mtrx = read.ENVI(filename)
#quickplot(mtrx,classes=FALSE, smoothing=TRUE,outname="/Users/davidschenkel/Documents/Uni/Masterarbeit/test2.png")
