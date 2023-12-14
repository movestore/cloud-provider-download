# Upload File from Cloud Storage
MoveApps

GitHub repository: *github.com/movestore/cloud-provider-download*

## Description

Insert movement data from your Dropbox or Google Drive cloud folder into the Workflow. Movement data can be a moveStack, move2 location object or a .csv data frame with specified object identifiers (see Documentation).

## Documentation
This App allows you to access movement data stored as an `.rds` or `.csv` file from your Dropbox or Google Drive folder that has been connected with your MoveApps account, to use as input to a Workflow. Note that the .rds file must contain a moveStack object (deprecated) or a move2 location object as specified in the [move2 R package](https://cran.r-project.org/web/packages/move2/index.html). The .csv file must contain the following four identifiers the names of which have to be specified in the Settings (see below). We recommend to follow the Movebank format:  

* [timestamp](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000200/) (yyyy-MM-dd HH:mm:ss.SSS in UTC)

* [individual-local-identifier](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000016/) (character)

* [location-long](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000146/) (decimal number indicating decimal degrees projected in the WGS84 reference system, using range -180 to 180)
* [location-lat](http://vocab.nerc.ac.uk/collection/MVB/current/MVB000145/) (decimal number indicating decimal degrees projected in the WGS84 reference system)

Check Movebank for [further possible attributes and their descriptions](http://vocab.nerc.ac.uk/collection/MVB/current/).

For data to be read properly, please note the following additional recommendations:  
* Missing values (NA) are not allowed, especially for locations and timestamps. If there are any, the respective event is removed by the App. 
* Timestamps must be ordered by individual. They will be reordered by the App, if not.
* Duplicate records for the same individual and timestamp are not permitted. They will be automatically removed by the App. 
* Additional columns are possible. For example, you can use this App to directly read files annotated with environmental information using the [EnvDATA System](https://www.movebank.org/cms/movebank-content/env-data) in Movebank.

To analyze data from multiple sources, this App can be inserted multiple times into a single Workflow or used in combination with the [Movebank Location App](https://www.moveapps.org/apps/browser/267eb5a9-41a8-4d1c-ad68-52769eac72a5) to access data from Movebank.

### Input data
none, moveStack or move2_loc object

### Output data
move2_loc object (uploaded file merged with App input if available)

### Artefacts
none

### Settings
1. The name of the file in the selected cloud storage folder.

2. `Name of the time column` (time_col): Column to use as the timestamp column for the transformation of the table data to a move2 object. The expected timestamp format is 'yyyy-mm-dd HH:MM:SS' and in UTC timezone. Default "timestamp".

3. `Name of the track ID column` (track_id_col): Column to use as the track ID column for transformation of the data table to a move2 object. Beware of possible issues if you have reused tags on different animals or used several tags on the same animal. If this is the case, create a column before uploading the data with a unique identifier for each animal and tag combination, e.g. by creating a 'animalName_TagID' column. Default "individual-local-identifier".

4. `Name of the attributes to become track attributes` (track_attr): List of attributes that are pure track attributes, i.e. have only one value per track. This will make working with the data easier in subsequent Apps. The names must be separated with comma. Default is the empty string "", i.e. no tack attributes.

5. `Names of the longitude and latitute columns` (coords): Names of the two (or three) coordinate columns in your data for correct transformation to a move2 object. The order must be x/longitude followed by y/latitute and optionally z/height. The names must be separated with comma. Default: "location-long, location-lat".

6. `Coordinate reference system` (crss): Coordinate reference system/ projection to useas a valid numeric EPSG value. For more info see https://epsg.io/ and https://spatialreference.org/. Default 4326 (EPSG:4326, standard longitude/latitude)

### Most common errors
What uploading a csv file, make sure that the timestamps are in the correct format, openening it in a text reader (not Excel!) helps to check for it.

**11 Nov 2023:** Due to changes in the requirement for Dropbox connections, we had to update MoveApps recently. Unfortunately, we have noted that some old Dropbox tokens for MoveApps are not valid anymore. Therefore, if you receive the error “expired_access_token” when using this “Upload data from Cloud Storage” App with Dropbox, you need to renew your Dropbox link to MoveApps as follows:
1.           Go to www.moveapps.org/users/profile (or login to MoveApps, click on your name on the top right and select “Profile”).
2.           Find your Dropbox card
3.           Click “DISCONNECT” and confirm
4.           Then click “CONNECT” (which has appeared on the Dropbox card after disconnecting) and confirm
5.           Login to the respective Dropbox account and authorize MoveApps there
Note that this update might affect Google Drive users, as well. For those, however, a re-selection of the folders and file is sufficient. Reconnection is not necessary.

### Null or error handling:
**File:** The selected file must be of the `.rds` or `.csv` file type. The `.rds` must be able to be interpreted by the R library move as moveStack or move2 as move2 object. `.csv` files require the in the Settings specified attributes/columns with exact names and standard format (YYYY-MM-DD HH:MM:SS.SSS for timestamp).
