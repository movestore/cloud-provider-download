source("Helper.R")

rFunction = function(
    settings=NULL,                # MoveApps settings (unused)
    file=NULL,                    # MoveApps settings section `file` (unused)
    folder=NULL,                  # MoveApps settings section `folder` (unused)
    id=NULL,                      # The id of the file in the cloud-provider context
    fileId=NULL,                  # The id of the file (includes folder of file)
    fileName=NULL,                # The original file-name (in cloud and placed locally)
    mimeType=NULL,                # The mime-type of the file (unused)
    cloudFileLocalFolder="/tmp",  # local directory of cloud-file
    data=NULL                     # The data of the prev. apps in the workflow
) {
  if (! is.null(fileId)) {
    logger.info(paste("Downloaded file '", fileId, "' from cloud provider.", sep = ""))
  }
  cloudSource <- NULL
  result <- NULL
  if (! is.null(fileName)) {
    cloudSource <- readInput(paste(cloudFileLocalFolder,"/",fileName,sep = ""))
    result <- cloudSource
    logger.info("Successfully read file from cloud provider (locally).")
  }
  if (exists("data") && !is.null(data)) {
    logger.info("Merging input and cloud download together")
    result <- moveStack(cloudSource, data)
  }
  logger.info("Done.")
  result
}
