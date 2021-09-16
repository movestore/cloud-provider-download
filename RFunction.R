rFunction = function(settings=NULL,file=NULL,folder=NULL,fileId=NULL,data=NULL) {
  if (! is.null(fileId)) {
    logger.info(paste("Downloaded file '", fileId, "' from cloud provider.", sep = ""))
  }
  if (! is.null(data)) {
    logger.info("Successfully got data from cloud provider.")
  }
  data
}
