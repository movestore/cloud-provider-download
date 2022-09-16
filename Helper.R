#
# Just a helper for local development. will no be bundled into the Docker MoveApps-App
#

# for loading move CSV files
library(move)

Sys.setenv(tz="UTC")

readInput <- function(sourceFile) {
  input <- NULL
  if(!is.null(sourceFile) && sourceFile != "") {
    if (file.info(sourceFile)$size == 0) {
        # handle the special `null`-input
        logger.warn("The App has received invalid input! It cannot process NULL-input. Aborting..")
        stop("The App has received invalid input! It cannot process NULL-input. Check the output of the preceding App or adjust the datasource configuration.")
    }
    logger.debug("Loading file from %s", sourceFile)
    input <- tryCatch({
        # 1: try to read input as move RDS file
        readRDS(file = sourceFile)
      },
      error = function(readRdsError) {
        tryCatch({
          # 2 (fallback): try to read input as move CSV file
          # first clean order of file as move() needs it, just to prevent some errors
          csvSource <- read.csv(sourceFile,header=TRUE)
          o <- order(csvSource$individual.local.identifier,as.POSIXct(csvSource$timestamp))
          move(csvSource[o,], removeDuplicatedTimestamps=TRUE)
          
        },
        error = function(readCsvError) {
          # collect errors for report and throw custom error
          stop(paste(sourceFile, " -> readRDS(sourceFile): ", readRdsError, "move(sourceFile): ", readCsvError, sep = ""))
        })
      })
  } else {
    logger.debug("Skip loading: no source File")
  }

  input
}
