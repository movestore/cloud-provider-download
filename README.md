# Upload File from Cloud Storage
MoveApps

GitHub repository: *github.com/movestore/cloud-provider-download*

## Description
Insert Movement data from your Dropbox or Google Drive Cloud Folder into the Workflow. Movement data can either be a moveStack, move2_loc object or a .csv data frame with required formats and names (see Documentation).

## Documentation
This App accesses your Dropbox or Google Drive Folder that your MoveApps account is connected with and allows the download of an `.rds` or `.csv` Movement data file. Note that the .rds file must contain either a moveStack object as specified in the R-move package (to be deprecated at some point) or a move2 object as specified in the move2 R-package. The .csv file needs to have the following four columns, the names of which can vary if specified in the settings below. However, formats must be as specified here: individual-local-identifier (character), location-long (decimal number), locaton-lat (decimal number), timestamp (yyyy-mm-dd hh:mm:ss.sss). Missing values (NA) are not allowed, especially for locations and timestamps. Timestamps have to be ordered by individual, and duplicates are not permitted, if there are any they will be removed (keepting the first occurance). Additional columns are possible and often helpful for uploading e.g. annotated tracks.

It is possible to directly read in tracks that have been annotated with environmental data by the EnvDATA service of Movebank.

This App has the purpose of providing a file as input to the workflow. The App can be inserted multiple times into a single workflow - this way you can insert more than one file from the cloud and even merge cloud-files by other data-source-files (like e.g. Movebank).

### Input data
none, moveStack or move2_loc object

### Output data
move2_loc object (uploaded file merged with input if available)

### Artefacts
none

### Settings
The name of the file in the context of the selected Cloud Storage.

`Name of the time column` (time_col): Column to use as the timestamp column for the transformation of the table data to a move2 object. The expected timestamp format is 'yyyy-mm-dd HH:MM:SS' and in UTC timezone. Default "timestamp".

`Name of the track ID column` (track_id_col): Column to use as the track ID column for transformation of the data table to a move2 object. Beware of possible issues if you have reused tags on different animals or used several tags on the same animal. If this is the case, create a column before uploading the data with a unique identifier for each animal and tag combination, e.g. by creating a 'animalName_TagID' column. Default "individual-local-identifier".

`Name of the attributes to become track attributes` (track_attr): List of attributes that are pure track attributes, i.e. have only one value per track. This will make working with the data easier in subsequent Apps. The names must be separated with comma. Default is the empty string "", i.e. no tack attributes.

`Names of the longitude and latitute columns` (coords): Names of the two (or three) coordinate columns in your data for correct transformation to a move2 object. The order must be x/longitude followed by y/latitute and optionally z/height. The names must be separated with comma. Default: "location-long, location-lat".

`Coordinate reference system` (crss): Coordinate reference system/ projection to useas a valid numeric EPSG value. For more info see https://epsg.io/ and https://spatialreference.org/. Default 4326 (EPSG:4326, standard longitude/latitude)

### Most common errors
What uploading a csv file, make sure that the timestamps are in the correct format, openening it in a text reader (not Excel!) helps to check for it.

**11 Nov 2023:** Due to changes in the requirement for Dropbox connections, we had to update MoveApps recently. Unfortunately, we have noted that some old Dropbox tokens for MoveApps are not valid anymore. Therefore, if you receive the error “expired_access_token” when using this “Upload data from Cloud Storage” App with Dropbox, you need to renew your Dropbox link to MoveApps as follows:
1.           Go to www.moveapps.org/users/profile (or login to MoveApps, click on your name on the top right and select “Profile”).
2.           Find your Dropbox card
3.           Click “DISCONNECT” and confirm
4.           Then click “CONNECT” (which has appeared on the Dropbox card after disconnecting) and confirm
5.           Login to the respective Dropbox account and authorize MoveApps there

### Null or error handling:
**File:** The selected file must be of the `RDS` or `CSV` file type. The rds must be able to be interpreted by the R library move as moveStack or move2 as move2 object. CSV files require the above listed attributes/columns with exact names and format.
