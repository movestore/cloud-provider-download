# Cloud Storage
MoveApps

Github repository: *github.com/movestore/cloud-provider-download*

## Description
Download Movement data from your Dropbox or Google Drive Cloud Folder.

## Documentation
This App accesses your Dropbox or Google Drive Folder that your MoveApps account is connected with and allow the download of an .rds or .csv Movement data file.

This App has the sole purpose of providing the file as input to the workflow.

### Input data
none

### Output data
moveStack in Movebank format

### Artefacts
none

### Parameters 
none

### Null or error handling:
**Data:** The selected file must be of the `RDS` or `CSV` (aka `movement`) type. It must be able to be interpreted by the R library move (by `readRDS(file = $SELECTED_FILE)` or `move(file = $SELECTED_FILE, removeDuplicatedTimestamps=TRUE)`).
