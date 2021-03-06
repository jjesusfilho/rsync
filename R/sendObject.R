#' Rsync API
#'
#' API to use rsync as persistent file and object storage.
#'
#' @inheritParams sendFile
#'
#' @details
#' \describe{
#'   Sends an object (from the environment) to a rsync target. If validate is
#'       TRUE the hash-sum of the remote file is compared to the local version.
#'       A warning is issued should they differ.
#' }
#' @export
sendObject <- function(db, ...) {
  UseMethod("sendObject", db)
}

#' Rsync API
#'
#' API to use rsync as persistent file and object storage.
#' @inheritParams sendFile
#' @param object object in the environment, which shall be sent to a target
#'     directory
#' @param objectName the object's name that is constructed from `object`
#' @param validate TRUE. validates if entryName is identical in both locations.
#' @param verbose FALSE. If set to TRUE, it prints details of the process.
#' @export
sendObject.default <- function(db, object, objectName = as.character(substitute(object)), validate = TRUE, verbose = FALSE, ...) {

  args <- if (verbose) "-ltvvx" else "-ltx"

  assign(objectName, object)
  dirName <- tempdir()
  save(
    list = objectName,
    file =  file <- paste0(dirName, "/", objectName, ".Rdata"),
    compress = TRUE
  )
  to <- db$to
  pre <- getPre(db)

  rsync(file, to, args = args, pre = pre)

  if ((validate) & (class(db)[1] != 'RsyncD'))
    identicalEntries(db, paste0(objectName, '.Rdata'))
}
