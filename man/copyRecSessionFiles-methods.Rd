% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RecSession.R
\docType{methods}
\name{copyRecSessionFiles}
\alias{copyRecSessionFiles}
\alias{copyRecSessionFiles,RecSession-method}
\alias{copyRecSessionFiles,ANY,ANY-method}
\title{Make a copy of the files of the recording session in another directory}
\usage{
copyRecSessionFiles(rs, destination, sessionSpecificExtensions,
  tetrodeSpecificExtensions)

\S4method{copyRecSessionFiles}{RecSession}(rs, destination,
  sessionSpecificExtensions, tetrodeSpecificExtensions)
}
\arguments{
\item{rs}{A RecSession object}

\item{destination}{A directory in which to do the backup.
If /data is given for destination, the data go in the directory /data/animalName/sessionName}

\item{sessionSpecificExtensions}{List of file extensions. These are in the format session.extension}

\item{tetrodeSpecificExtensions}{List of file extensions. These are in the format session.extension.tetrodeNo}
}
\description{
This is used to export the data of an experiment.
}
