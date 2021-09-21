library(jsonlite)
library(move)
source("logger.R")
source("Helper.R")
source("RFunction.R")

inputFromPrevApp = "input4.rds"
cloudFileName = "input.csv"
cloudFileLocalFolder = "."
outputFileName = "output.rds"

args <- list()

#################################################################
########################### Arguments ###########################
# The data parameter will be added automatically if input data is available
# The name of the field in the vector must be exactly the same as in the r function signature
# Example:
# rFunction = function(username, password)
# The parameter must look like:
#    args[["username"]] = "any-username"
#    args[["password"]] = "any-password"

# Add your arguments of your r function here
args[["fileId"]] = "some-id"
args[["fileName"]] = cloudFileName
args[["cloudFileLocalFolder"]] = cloudFileLocalFolder

#################################################################
#################################################################

inputData <- readInput(inputFromPrevApp)
# Add the data parameter if input data is available
if (!is.null(inputData)) {
  args[["data"]] <- inputData
}

result <- tryCatch({
  do.call(rFunction, args)
},
error = function(e) {
  logger.error(paste("ERROR:", e))
  stop(e) # re-throw the exception
}
)

if(!is.null(outputFileName) && outputFileName != "" && !is.null(result)) {
  logger.info(paste("Storing file to '", outputFileName, "'", sep = ""))
  saveRDS(result, file = outputFileName)
} else {
  logger.warn("Skip store result: no output File or result is missing.")
}