rFunction = function(settings=NULL,file=NULL,folder=NULL,fileId=NULL,data=NULL) {
  if (! is.null(fileId)) {
    cat("This data-source will use the configured file", fileId, ".\n")
  }
  if (! is.null(data)) {
    cat("File from cloud provider received.\n")
  }
  data
}
