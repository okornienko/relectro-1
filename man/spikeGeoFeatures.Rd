% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpikeExtraction.R
\name{spikeGeoFeatures}
\alias{spikeGeoFeatures}
\title{Get the geometrical features of the spikes, treating each channel independently}
\usage{
spikeGeoFeatures(swf)
}
\arguments{
\item{swf}{Array with the spike waveforms [spike,time,channel]}
}
\value{
Matrix. Each column is a feature and each row is a spike. 
There are 5 features per channel in the swf array. 
The features are amplitude, width, widthFirstHalf, widthSecondHalf, spikeAsymmetry for each spike.
}
\description{
The geometrical features are amplitude, width at 50% of amplitude, width first half, width second half and spike asymmetry
}
