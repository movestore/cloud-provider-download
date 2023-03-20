# Upload File from Cloud Storage
MoveApps

GitHub repository: *github.com/movestore/cloud-provider-download*

## Description
Insert Movement data from your Dropbox or Google Drive Cloud Folder into the Workflow. Movement data can either be a moveStack or a .csv data frame with required formats and names (see Documentation).

## Documentation
This App accesses your Dropbox or Google Drive Folder that your MoveApps account is connected with and allows the download of an `.rds` or `.csv` Movement data file. Note that the .rds file must contain a moveStack object as specified in the R-move package. The .csv file need to have the following six columns with the exact names and formats: individual.local.identifier (character), location.long (decimal number), locaton.lat (decimal number), timestamp (yyyy-mm-dd hh:mm:ss.sss), individual.taxon.canonical.name (Latin name of your species) and sensor.type (e.g. gps). Missing values (NA) are not allowed, especially for locations and timestamps. Timestamps have to be ordered by individual, and duplicates are not permitted. Additional columns are possible and often helpful for uploading e.g. annotated tracks.

It is possible to directly read in tracks that have been annotated with environmental data by the EnvDATA service of Movebank.

This App has the purpose of providing a file as input to the workflow. The App can be inserted multiple times into a single workflow - this way you can insert more than one file from the cloud and even merge cloud-files by other data-source-files (like e.g. Movebank).

### Input data
none or moveStack

### Output data
moveStack in Movebank format csv (merged with input if necessary)

### Artefacts
none

### Settings
The name of the file in the context of the selected Cloud Storage.

### Null or error handling:
**File:** The selected file must be of the `RDS` or `CSV` (aka `movement`) type. It must be able to be interpreted by the R library move (by `readRDS(file = $SELECTED_FILE)` or `move(file = $SELECTED_FILE, removeDuplicatedTimestamps=TRUE)`).
