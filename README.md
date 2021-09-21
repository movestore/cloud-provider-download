# Cloud Storage
MoveApps

GitHub repository: *github.com/movestore/cloud-provider-download*

## Description
Insert Movement data from your Dropbox or Google Drive Cloud Folder into the Workflow.

## Documentation
This App accesses your Dropbox or Google Drive Folder that your MoveApps account is connected with and allow the download of an `.rds` or `.csv` Movement data file.

This App has the sole purpose of providing the file as input to the workflow. The App can be inserted multiple times into a single workflow - this way you can insert more than one file from the cloud and even merge cloud-files by other data-source-files (like e.g. Movebank).

### Input data
none or moveStack

### Output data
moveStack in Movebank format (merged if necessary)

### Artefacts
none

### Parameters 
The ID of the file in the context of the selected Cloud Storage.

### Null or error handling:
**File:** The selected file must be of the `RDS` or `CSV` (aka `movement`) type. It must be able to be interpreted by the R library move (by `readRDS(file = $SELECTED_FILE)` or `move(file = $SELECTED_FILE, removeDuplicatedTimestamps=TRUE)`).
