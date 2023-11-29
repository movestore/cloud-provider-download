# Upload File from Cloud Storage
MoveApps

GitHub repository: *github.com/movestore/cloud-provider-download*

## Description
Insert movement data from your Dropbox or Google Drive cloud folder into the Workflow. Movement data can be a moveStack or a .csv data frame with required formats and names (see Documentation).

## Documentation
This App allows you to connect your MoveApps account with your Dropbox or Google Drive folder and access movement data stored as an `.rds` or `.csv` file to use as input to a Workflow. Note that the .rds file must contain a moveStack object as specified in the [move2 R package](https://cran.r-project.org/web/packages/move2/index.html). The .csv file must contain the following six columns, with the exact names and formats, generally following the Movebank format:  
* [individual.local.identifier](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000016/) (character)
* [location.long](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000146/) (decimal number indicating decimal degrees projected in the WGS84 reference system, using range -180 to 180)
* [location.lat](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000145/) (decimal number indicating decimal degrees projected in the WGS84 reference system)
* [timestamp](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000200/) (yyyy-MM-dd HH:mm:ss.SSS in UTC)
* [individual.taxon.canonical.name](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000024/) (Latin name of your species)
* [sensor.type](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000170/) (e.g., gps)

For data to be read properly, please note the following additional requirements:  
* Missing values (NA) are not allowed, especially for locations and timestamps. 
* Timestamps must be ordered by individual.
* Duplicate records for the same individual and timestamp are not permitted. 
* Additional columns are possible. For example, you can use this App to directly read files annotated with environmental information using the [EnvDATA System](https://www.movebank.org/cms/movebank-content/env-data) in Movebank.

To analyze data from multiple sources, this App can be inserted multiple times into a single Workflow or used in combination with the [Movebank App](https://www.moveapps.org/apps/browser/8eeafaad-410e-440b-a105-94f6ff4109d8) to access data from Movebank.

### Input data
none or moveStack

### Output data
moveStack in Movebank format (merged with input from other Apps if used)

### Artefacts
none

### Settings
The name of the file in the selected cloud storage folder.

### Most common errors
**11 Nov 2023:** Due to changes in the requirement for Dropbox connections, we had to update MoveApps recently. Unfortunately, we have noted that some old Dropbox tokens for MoveApps are not valid anymore. Therefore, if you receive the error “expired_access_token” when using this “Upload data from Cloud Storage” App with Dropbox, you need to renew your Dropbox link to MoveApps as follows:
1.           Go to www.moveapps.org/users/profile (or login to MoveApps, click on your name on the top right and select “Profile”).
2.           Find your Dropbox card
3.           Click “DISCONNECT” and confirm
4.           Then click “CONNECT” (which has appeared on the Dropbox card after disconnecting) and confirm
5.           Login to the respective Dropbox account and authorize MoveApps there


### Null or error handling:
**File:** The selected file must be of the `RDS` or `CSV` (aka `movement`) type. It must be able to be interpreted by the R library move (by `readRDS(file = $SELECTED_FILE)` or `move(file = $SELECTED_FILE, removeDuplicatedTimestamps=TRUE)`).
