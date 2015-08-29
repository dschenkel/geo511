# statistics for maps
#

library(caTools)
library(raster)
library(stats)
library(zoo)





correlate_2d <- function(map1, map2, namelist, mask ){
	
   # stopifnot(checkDim3(A,B))
    A = map1*mask
    B = map2*mask
	
	datafr = data.frame(as.vector(A), as.vector(B))
	colnames(datafr) <- c(namelist$map1,namelist$map2)
	#print(A.vec)
	#print(B.vec)
	#cor = cor(A.vec,B.vec,method="pearson",use="pairwise.complete.obs")
	#print(cor)
	#print(cor.test(A.vec,B.vec))
	lm.out = lm(datafr)
	jpeg(paste(namelist$outdir,namelist$statfile,"_corr.jpg",sep=""))
	plot(datafr, main=namelist$title)
	abline(lm.out, col="red")
	legend("bottomright", bty="n", legend=paste("R2 = ", format(summary(lm.out)$adj.r.squared, digits=4)))
	dev.off()
	print(nobs(lm.out))
	#par(mfrow=c(2,2))
	#jpeg(paste(outdir,"stats.jpg",sep=""))
	#plot(lm.out)
	#dev.off()
	lmOut(lm.out, paste(namelist$outdir,namelist$statfile,".csv",sep=""))

	#return(object)	
}

days_per_decade.proc <- function(vector, years, annual) {
	years = 1982:2011
	out = lm(vector ~ years)
	if(annual == TRUE) {
		fac = 1.0
	} else {
		fac = 10.0
	}
	sout = summary(out)
	if(is.na(sout$coefficients["years",4])) {
		return(NA)
	}
	#print(sout$coefficients["years",4])
	if(sout$coefficients["years",4]<=0.1) {
		ndays = out$coefficients["years"]*fac
		return(ndays)
	}
	else {
		return(NA)
	}
}

days_per_decade <- function(map,annual=FALSE) {
	map.dim = dim(map)
	output = array(dim=c(map.dim[1],map.dim[2]))
	for(i in 1:map.dim[1]) {
		for(j in 1:map.dim[2]) {
			vec = as.vector(map[i,j,])
			if(sum(is.na(vec)) > 10 || is.na(vec[1]) || is.na(vec[30])) {
				output[i,j] = NA
			} 
			else {
				if(sum(is.na(vec)) != 0) {
					zVec <- zoo(vec)
					#index(zVec) <- zVec[,1]
					zVec_approx <- na.approx(zVec)
					
					output[i,j] = days_per_decade.proc(zVec_approx,annual=annual)
				} else {
					output[i,j] = days_per_decade.proc(vec,annual=annual)
				}
			}
		}
	}
	return(output)
}

lmOut <- function(res, file="test.csv", ndigit=3, writecsv=T) {
  # If summary has not been run on the model then run summary
  n_ob = nobs(res)
  if (length(grep("summary", class(res)))==0) res <- summary(res)
  
  co <- res$coefficients
  nvar <- nrow(co)
  ncol <- ncol(co)
  f <- res$fstatistic
  formatter <- function(x) format(round(x,ndigit),nsmall=ndigit)
  
  # This sets the number of rows before we start recording the coefficients
  nstats <- 4
  
  # G matrix stores data for output
  G <- matrix("", nrow=nvar+nstats, ncol=ncol+2)
    
  G[1,1] <- toString(res$call)
  
  # Save rownames and colnames
  G[(nstats+1):(nvar+nstats),1] <- rownames(co)
  G[nstats, 2:(ncol+1)] <- colnames(co)
  
  # Save Coefficients
  G[(nstats+1):(nvar+nstats), 2:(ncol+1)] <- formatter(co)
  
  # Save F-stat
  G[1,2] <- paste0("F(",f[2],",",f[3],")")
  G[2,2] <- formatter(f[1])
  
  # Save F-p value
  G[1,3] <- "Prob > P"
  G[2,3] <- formatter(1-pf(f[1],f[2],f[3]))
  
  # Save R2
  G[1,4] <- "R-Squared"
  G[2,4] <- formatter(res$r.squared)
  
  # Save Adj-R2
  G[1,5] <- "Adj-R2"
  G[2,5] <- formatter(res$adj.r.squared)
  
  G[1,6] <- "Number of observation"
  G[2,6] <- n_ob
  
  print(G)
  if (writecsv) write.csv(G, file=file, row.names=F)
}