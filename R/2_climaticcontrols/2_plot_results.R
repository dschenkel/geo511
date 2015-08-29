source("quickplot.R")
month <- c("jana","janb","feba","febc","mara","marb","apra","aprb","maya","mayb","juna","junb","jula","julb","auga","augb","sepa","sepb","octa","octb","nova","novb","deca","decb")

for(prod in c("TEMP_FAC","MOIST_FAC")) {
	mtrx.seasonal = matrix(0,nrow=360,ncol=720)
	
	for(i in 1:24) {
		

		filename.wtr = "~/Documents/Uni/Masterarbeit/watermask/watermask.envi"
		mask = read.ENVI(filename.wtr)
		mask[mask==0] <- NA
		filename = paste("~/Documents/Uni/Masterarbeit/2_controls/bimonthly_changes/",prod,"_",i,sep="")
		mtrx = read.ENVI(filename) #in annual percent
		
		mtrx.n = mtrx
		mtrx.n[is.na(mtrx.n)] <- 0
		mtrx.seasonal = mtrx.seasonal + mtrx.n
				
		if(i %% 6 == 0) {
			mtrx.seasonal = (mtrx.seasonal*mask)/6
			classes = classify_image.div(mtrx.seasonal,9,0.01)
			classes.names = name_classes(classes)
			colorPal = brewer.pal(9,"BrBG")
			filename.out = paste("~/Documents/Uni/Masterarbeit/2_controls/bimonthly_changes/plots/quarter_",prod,"_",i,".png",sep="")
			quickplot(mtrx.seasonal, classes=classes, classes.names = classes.names, color=colorPal, smoothing=FALSE, outname=filename.out)
			mtrx.seasonal = matrix(0,nrow=360,ncol=720)
		}

	}
}


filename.uchanges = "~/Documents/Uni/Masterarbeit/2_controls/unique_dominating_factors"
mtrx = read.ENVI(filename.uchanges) 
classes = c(0.5,1.5,2.5,3.5)
classes.names = c("no change in domniating control", "change between 2 controls", "change between 3 controls")
colorPal = brewer.pal(3,"Pastel1")
colorPal[1] = "#FFFFFF"
quickplot(mtrx,classes=classes,classes.names=classes.names,colors=colorPal,outname=paste(filename.uchanges,".png",sep=""))

#plot bimonthly changes
for(prod in c("TEMP_FAC","MOIST_FAC")) {
	mtrx.seasonal = matrix(0,nrow=360,ncol=720)
	
	for(i in 1:24) {
		

		#if(i==2 & prod=="MOIST_FAC") {
	#		next()
#		}
		filename = paste("~/Documents/Uni/Masterarbeit/2_controls/bimonthly_changes/",prod,"_",i,sep="")
		mtrx = read.ENVI(filename) #in annual percent
		
		

	
		#classes.min = min(mtrx,na.rm=TRUE)
		#classes.max = max(mtrx,na.rm=TRUE)
		#classes.mid = 0.05 
		#classes.bmid = -0.05+(classes.min+0.05)/2
		#classes.umid = 0.05+(classes.max-0.05)/2
		
		#classes = c(classes.min,classes.bmid,-classes.mid,classes.mid,classes.umid,classes.max)
		
		#classes.names = c(paste(signif(classes.min,digits=3),"-",signif(classes.bmid,digits=3)),
		#paste(signif(classes.bmid,digits=3),"-",signif(-classes.mid,digits=3)),
		#paste(signif(-classes.mid,digits=3),"-",signif(classes.mid,digits=3)),#
		#paste(signif(classes.mid,digits=3),"-",signif(classes.umid,digits=3)),
		#paste(signif(classes.umid,digits=3),"-",signif(classes.max,digits=3))
		#)
		filename.out = paste("~/Documents/Uni/Masterarbeit/2_controls/bimonthly_changes/plots/",prod,"_",i,"_",month[i],".png",sep="")
		
		classes = classify_image.div(mtrx,5,0.05)
		classes.names = name_classes(classes)
		colorPal=brewer.pal(5,"BrBG")
		quickplot(mtrx,classes=classes,classes.names=classes.names,color=colorPal, smoothing=FALSE, outname=filename.out)
		
	}
}





source("quickplot.R")


# yearly dominating controls
for(year in 1982:2011) {
	filename = paste("~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/",year,"_dominating_control",sep="")
	filename.out = paste("~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/plots/",year,"_dominating_control.png",sep="")
	mtrx = read.ENVI(filename)
	
	classes=c(0.5,1.5,2.5,3.5)
	classes.names = c("Temperature","Moisture","Radiation")
	colorPal=brewer.pal(3,"Pastel1")
	quickplot(mtrx,classes=classes,color=colorPal,classes.names=classes.names, smoothing=FALSE, outname=filename.out)
	
	filename = paste("~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/new_meth/dominating_control_",year,sep="")
	filename.out = paste("~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/new_meth/plots/dominating_control",year,".png",sep="")
	mtrx = read.ENVI(filename)
	
	classes=c(0.5,1.5,2.5,3.5)
	classes.names = c("Temperature","Moisture","Radiation")
	colorPal=brewer.pal(3,"Pastel1")
	quickplot(mtrx,classes=classes,color=colorPal,classes.names=classes.names, smoothing=FALSE, outname=filename.out)
	
}
#filename = "~/Documents/Uni/Masterarbeit/2_controls/yearly_dominating/1982_dominating_control"
#mtrx = read.ENVI(filename)
#quickplot(mtrx,classes=FALSE, smoothing=TRUE,outname="/Users/davidschenkel/Documents/Uni/Masterarbeit/test2.png")
