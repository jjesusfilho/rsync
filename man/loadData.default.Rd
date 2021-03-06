% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loadData.R
\name{loadData.default}
\alias{loadData.default}
\title{Rsync API}
\usage{
\method{loadData}{default}(db, dataName, verbose = FALSE, ...)
}
\arguments{
\item{db}{rsync object that contains information on the type of connection,
the target directory (remote or local) and eventually a password.}

\item{dataName}{name of data file}

\item{verbose}{FALSE. If set to TRUE, it prints details of the process.}

\item{...}{additional arguments}
}
\description{
API to use rsync as persistent file and object storage.
}
