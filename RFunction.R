# for loading move1, move2 or CSV files
# still allow moveStack objects...

# need to update to add (like in Upload from Local App) settings: time_col="timestamp", track_id_col="individual.local.identifier", track_attr="",coords="location.long,location.lat",crss=4326


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
    data=NULL,                     # The data of the prev. apps in the workflow
    time_col="timestamp",
    track_id_col="individual.local.identifier", 
    track_attr="",
    coords="location.long,location.lat",
    crss=4326
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
          # 2 (fallback): try to read input as CSV file in format as specified above (Movebank col. names not required any more)
   
          csvSource <-  vroom::vroom(paste(cloudFileLocalFolder,"/",fileName,sep = ""), delim = ",") # alternative to read.csv, takes care of timestamps, default timezome is UTC, problems with empty table avoided above
          if(length(grep(",",coords)) %in% c(1,2)){
            coo <- trimws(strsplit(as.character(coords),",")[[1]])
            logger.info(paste("You have defined as coordinate columns:",coords))
          } else {
            coo <- NULL
            logger.info("An incorrect number of coordinate columns is provided; expecting two (x,y) or three (x,y,z). Cannot transform csv data to move2.")
            csvSource <- NULL
          }
          if(!is.null(csvSource)){
            logger.info("New data uploaded from csv file, this file is expected to be comma delimited.")
            logger.info(paste("You have defined as datetime column: ",time_col,".", " The expected timestamp format is 'yyyy-mm-dd HH:MM:SS' and in UTC timezone"))
            logger.info(paste("You have defined as track ID column: ",track_id_col,"."))
            logger.info(paste("You have defined as track attributes: ",track_attr,"."))
            logger.info(paste("You have defined as projection (crs): ",crss,".", " The expected projection is a valid numeric EPSG value. For more info see https://epsg.io/ and https://spatialreference.org/"))
            
            #this only if a comma in the data!
            if(length(grep(",",track_attr))>0){tr_attr <- trimws(strsplit(as.character(track_attr),",")[[1]])} else {tr_attr <- track_attr}
            
            # transform data.frame to move2 object
            csvSource <- dplyr::filter(csvSource,!is.na(csvSource[[track_id_col]])) # if there is a NA in the track_id col, mt_as_move2() gives error
            n.trcolna <- length(which(is.na(csvSource[[track_id_col]])))
            if (n.trcolna>0) logger.info(paste("Your tracks contained",ntrcolna,"locations with unspecified track ID. They have been removed."))
            cloudSource <- mt_as_move2(csvSource,
                                time_column=time_col,
                                track_id_column=track_id_col,
                                track_attributes=track_attr,
                                coords=coo,
                                crs=crss,
                                na.fail=FALSE)
            ## remove empty locations
            cloudSource <- cloudSource[!sf::st_is_empty(cloudSource),]  
            if(nrow(cloudSource)==0){logger.info("Your uploaded csv file does not contain any location data.")}
            
            ## remove duplicated timestamps
            if(!mt_has_unique_location_time_records(cloudSource)){
              n_dupl <- length(which(duplicated(paste(mt_track_id(cloudSource),mt_time(cloudSource)))))
              logger.info(paste("Your data has",n_dupl, "duplicated location-time records. We removed here those with less info and then select the first if still duplicated."))
              ## this piece of code keeps the duplicated entry with least number of columns with NA values
              cloudSource <- cloudSource %>%
                mutate(n_na = rowSums(is.na(pick(everything())))) %>%
                arrange(n_na) %>%
                mt_filter_unique(criterion='first') # this always needs to be "first" because the duplicates get ordered according to the number of columns with NA. 
            }
            
            ## ensure timestamps are ordered within tracks
            cloudSource <- dplyr::arrange(cloudSource, mt_track_id(cloudSource), mt_time(cloudSource)) 
            
            # make names for cloudSource
            names(cloudSource) <- make.names(names(cloudSource),allow_=TRUE)
            mt_track_id(cloudSource) <- make.names(mt_track_id(cloudSource),allow_=TRUE)
          }

          # first clean order of file as move2() needs it, just to prevent some errors
          #csvSource <- read.csv(paste(cloudFileLocalFolder,"/",fileName,sep = ""),header=TRUE)
          #o <- order(csvSource$individual.local.identifier,as.POSIXct(csvSource$timestamp))
          #mt_as_move2(csvSource[o,],time_column="timestamp",track_id_column="individual.local.identifier",coords=c("location.long","location.lat"),crs="WGS84",na.fail=FALSE)
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
    result <- mt_stack(cloudSource, data, .track_combine="rename",.track_id_repair="universal") #how is it with the timezones in this function? Do we have to force a fix here, again?
    
  } else {
    logger.info("No input from prev. app provided, nothing to merge. Will deliver the mapped cloud-file only.")
  }
  
  logger.info("I'm done.")
  return(result)
}
