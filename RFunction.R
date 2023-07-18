# for loading move1, move2 or CSV files
# still allow moveStack objects...
library(move2)
library(move)
# for reading files from disk
source("./src/io/rds.R")

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
  Sys.setenv(tz="UTC") #fix, so that time zones will be transformed into UTC (input RDS files (or data from prev app) with tz=NULL are forced to UTC) -> requires that timezone is UTC, add to documentation!
  
  if (! is.null(fileId)) {
    logger.info(paste("Download file '", fileId, "' from cloud provider.", sep = ""))
  }
  
  cloudSource <- NULL
  result <- NULL
  
  if (! is.null(fileName)) {   
       cloudSource <- tryCatch({
        # 1: try to read input as (any) RDS file
        readRdsInput(paste(cloudFileLocalFolder,"/",fileName,sep = ""))
      },
      error = function(readRdsError) {
        tryCatch({
          # 2 (fallback): try to read input as CSV file in Movebank format
          # first clean order of file as move2() needs it, just to prevent some errors
          csvSource <- read.csv(paste(cloudFileLocalFolder,"/",fileName,sep = ""),header=TRUE)
          o <- order(csvSource$individual.local.identifier,as.POSIXct(csvSource$timestamp))
          mt_as_move2(csvSource[o,],time_column="timestamp",track_id_column="individual.local.identifier",coords=c("location.long","location.lat"),crs="WGS84",na.fail=FALSE)
        },
        error = function(readCsvError) {
          # collect errors for report and throw custom error
          stop(paste(sourceFile, " -> readRDS(sourceFile): ", readRdsError, "mt_as_move2(sourceFile): ", readCsvError, sep = "")) #this has to be adapted by Clemens
        })
      })
       
    if (any(class(cloudSource)=="MoveStack")) cloudSource <- mt_as_move2(cloudSource) #transform moveStack to move2 object if necessary
      
    result <- cloudSource
    logger.info("Successfully read file from cloud provider (locally).")
  }
  
  if (exists("data") && !is.null(data)) {
    logger.info("Merging input from prev. app and cloud file together.")
    result <- mt_stack(cloudSource, data, .track_combine="rename") #how is it with the timezones in this function? Do we have to force a fix here, again?
    
  } else {
    logger.info("No input from prev. app provided, nothing to merge. Will deliver the mapped cloud-file only.")
  }
  
  logger.info("I'm done.")
  return(result)
}
