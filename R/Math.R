#' Get the standard error of the mean
#' 
#' The standard deviation divided by the square root of n
#' 
#' @param x Numeric vector
#' @return Numeric, standard error of the mean
sem<-function(x){sd(x,na.rm=T)/sqrt(length(x))}


#' Get the mode of a distribution
#' 
#' This get you the value with the highest frequency in a vector 
#' 
#' @param x Numeric vector
#' @return The value in the vector with the highest frequency
modeRelectro <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#' Returns possible pairs from one or two vectors of values
#' 
#' If only one vector of values is given, all unique pairs within these values are returned.
#' For example 2-3 is there but not 3-2.
#' 
#' If two vectors of values are given, all possible combinations of the two vectors are returned.
#' For example 2-2 if both vectors contain number 2, 2-3 and 3-2 would be included if 2 and 3 are in both vectors.
#' 
#' @param cl1 Numeric vector containing a vector of values
#' @param cl2 Optional argument containing a second vector of values
#' @param excludeOneNumberPair Logical indicating whether to include pairs with the same number when two vectors are used (e.g 2-2).
#' @return A data.frame containing the pairs
#' @examples makePairs(cl1=1:10)
makePairs<-function(cl1="",cl2=NULL,excludeOneNumberPair=TRUE){
  if(is.null(cl2)){
    m<-combn(cl1,m=2)
    df<-data.frame(Var1=m[1,],Var2=m[2,])
  }
  else{
    df<-expand.grid(cl1,cl2)
    if(excludeOneNumberPair==TRUE)
    {
      df<-df[which(df[,1]!=df[,2]),]
    }
  }
  return(df)
}

#' Smooth the values in a numeric vector using a Gaussian kernel
#' 
#' The values at -1.0 are consider invalid by defaults and are not used or changed. 
#' Set the value of the argument degrees to TRUE if the data are circular. 
#' For example, if the first and last data of the vector should be considered next to each other.
#' 
#' @param x Numeric vector
#' @param sd The standard deviation of the Gaussian kernel used to smooth
#' @param invalid Numeric indicating which value should be treated as NA, by default -1.0.
#' The value should be a numeric.
#' @param degrees Logical indicating if the smoothing should consider the vector as circular, i.e. the first and last values are adjacent.
#' @examples smoothGaussian(x=c(1:10,9:1),sd=2,invalid=-1.0,degrees=FALSE)
smoothGaussian<-function(x,sd=2,invalid=-1.0,degrees=FALSE)
{
  if(length(x)==0)
    return
  if(sd==0)
    return
  if(sd<0)
    stop(paste("sd is smaller than 0:",sd))
  if(class(x)=="integer"){
    x<-as.numeric(x)
  }
  if(class(invalid)!="numeric")
    stop(paste("invalid should be a numeric"))

    if(degrees==FALSE){
    results<- .Call("smooth_double_gaussian_cwrap",
                    x, length(x), sd, invalid)
  }
  if(degrees==TRUE){
    if(any(x>360))
      stop(paste("x values larger than 360"))
    results<-.Call("smooth_double_gaussian_degrees_cwrap",
                     x, length(x), sd, invalid)
  }
  return(results)
}

#' Shift values in a vector by a certain number of places and in a given direction
#' 
#' The vector is wrapped around so that values that would end up after the end of the vector are place at the beginning.
#' 
#' @param v A vector
#' @param places Number of places the values will be moved.
#' @param dir Direction of the shift, values should be right or left (or r or l).
#' @examples shift(v=1:10, place=2, dir="r")
shift <- function (v, places, dir = "right") 
{# shift a vector in place
  vnew <- NULL
  d <- substring(dir, 1, 1)
  if (d == "r" & places < 0) {
    d <- "l"
  }
  else {
    if (d == "l" & places < 0) {
      d <- "r"
    }
  }
  n <- length(v)
  p <- abs(places)
  if (p == 0) {
    vnew <- v
  }
  else {
    if (d == "r") {
      vnew <- c(v[(n - p + 1):n], v[1:(n - p)])
    }
    else {
      vnew <- c(v[(p + 1):n], v[1:p])
    }
  }
  return(vnew)
}

#' Shift a the values of a vector by a random amount that is at least as large as the argument minMvMs
#' 
#' @param x A vector
#' @param timePerSampleRes Time in sample values (from the .dat files) between the position sample
#' @param minMvMs Minimum shift in ms 
#' @param samplingRate Sampling rate of the .dat files.
#' @examples shiftPositionVector(x=1:100, timePerSampleRes=400, minMvMs = 1000, samplingRate=20000)
shiftPositionVector<-function(x,
                         timePerSampleRes,
                         minMvMs,
                         samplingRate){
  minMv<- minMvMs*(samplingRate/1000)/timePerSampleRes
  mv<-sample(minMv:length(x)-minMv,1)
  return(shift(x,mv))
}

#' Shift a the values of two vectors by a random amount that is at least as large as the argument minMvMs
#' 
#' The two vectors are shifted by the same amount.
#' 
#' @param x A vector
#' @param y A second vector
#' @param timePerSampleRes Time in sample values (from the .dat files) between the position sample
#' @param minMvMs Minimum shift in ms 
#' @param samplingRate Sampling rate of the .dat files.
#' @examples shiftPositionVectors(x=1:100,y=201:300, timePerSampleRes=400, minMvMs = 1000, samplingRate=20000)
shiftPositionVectors<-function(x,y,
                         timePerSampleRes,
                         minMvMs,
                         samplingRate){
  minMv<- minMvMs*(samplingRate/1000)/timePerSampleRes
  mv<-sample(minMv:length(x)-minMv,1)
  x<-shift(x,mv)
  y<-shift(y,mv)
  return(list(x=x,y=y))
}


#' Calculate the center of mass of a matrix, numeric or integer
#' 
#' The values returned are in indices with first bin being 1 and last being length(x)
#' 
#' @param x A matrix
#' @return Numeric of length 2 with the x and y coordinate of the center fo mass
centerOfMass<-function(x){
  if(class(x)=="matrix")
  {
    s<-sum(x,na.rm=T)
    if(s==0)
      return(c(NA,NA))
    sr<-sum(apply(x,1,sum,na.rm=T)*1:length(x[,1]))
    sc<-sum(apply(x,2,sum,na.rm=T)*1:length(x[1,]))
    return(c(sr/s,sc/s))
  }
  if(class(x)=="integer"|class(x)=="numeric")
  {
    return(sum(x*1:length(x))/sum(x,na.rm=T))
  }
}


#' Perform r-to-Z transform to get significance of difference between two correlation coefficients
#' 
#' @param r1 correlation coefficient of the first correlation
#' @param n1 number of observations in the first correlation
#' @param r2 correlation coefficient of the second correlation
#' @param n2 number of observations in the second correlation
cor.diff <- function(r1,n1,r2,n2 ){
  if(r1 < -1.0|r1 > 1.0)
    stop(paste("r1 is out of range:",r1))
  if(r2 < -1.0|r2 > 1.0)
    stop(paste("r2 is out of range:",r2))
  Z1 <- 0.5 * log( (1+r1)/(1-r1) )
  Z2 <- 0.5 * log( (1+r2)/(1-r2) )
  diff   <- Z1 - Z2
  SEdiff <- sqrt( 1/(n1 - 3) + 1/(n2 - 3) )
  diff.Z  <- diff/SEdiff
  p <- 2*pnorm( abs(diff.Z), lower.tail=F)
  cat( "Difference between ",r1,"(",n1,") and ",r2,"(",n2,")", "two-tailed p value:", p , "\n" )
} 

