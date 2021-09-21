# hint: during docker built packrat will find these dependencies on its own (via `packrat::init() in `init-by-packrat.R`)
# for parsing JSON
library(jsonlite)
# for http communication
library(httr)
# for loading move CSV files
library(move)

readInput <- function(sourceFile) {
  input <- NULL
  if(!is.null(sourceFile) && sourceFile != "") {
    logger.debug("Loading file from %s", sourceFile)
    input <- tryCatch({
        # 1: try to read input as move RDS file
        readRDS(file = sourceFile)
      },
      error = function(readRdsError) {
        tryCatch({
          # 2 (fallback): try to read input as move CSV file
          move(sourceFile, removeDuplicatedTimestamps=TRUE)
        },
        error = function(readCsvError) {
          # collect errors for report and throw custom error
          stop(paste(readRdsError, readCsvError, sep = " & "))
        })
      })
  } else {
    logger.debug("Skip loading: no source File")
  }

  input
}


