## SCRIPT DESCRIPTION
## 
## A Script that Searches a Given Directory (default is current directory) for the Extention parameter given.
## The Files with extention matched will be (Copied/Moved) to the output directory and matched up with
##    it's Created Date Meta Data.
## 
## SearchDir        - The Directory that will be searched recursively (Subdirectories) for the given extention
## OutputDir        - The Output directory for the files found with the extention
## extMatch         - The Extension that will be searched for (RegEx)
## NoDamage         - Enables Coping the items instead of Moving them to the Output Directory
## DisplayOutput    - Enables Displaying ALL Output to Console
## 
## 
## PARAMETERS
##  - Required:
##      - extMatch
##
##  - Optional:
##      - SearchDir
##      - OutputDir
##      - NoDamage
##      - DisplayOutput
## 
##

# Script Parameters
param(
    $SearchDir = "./",          # The Directory Path that will be searched
    $OutputDir = "./Out",       # The Output Directory Path that the Files will be stored in
    $extMatch = "",             # The Extension to search for (RegEx)
    [switch] $NoDamage,         # Copies Data instead of Moving it (No Damage to Data)
    [switch] $DisplayOutput     # Displays All Output
)

# Global Variables
$global:total = 0;


# Searches Directory given
# Recursively calls itself if subdirectory
function searchDir($dir) {
    Get-ChildItem $dir | ForEach-Object {
        # Search Subdirectory Recursively
        # Make sure NOT to search the Output Directory (Causing double searches & occasional errors)
        if( -not $_.Extension -and $_.FullName -ne $OutputDir.toString() ) {
            if($DisplayOutput) { Write-Output "DIR+" }
            searchDir -dir $_.FullName;
            if($DisplayOutput) { Write-Output "DIR-" }
        }

        # Extension Match | Make sure Extension is not empty
        if ($extMatch -match $_.Extension -and $_.Extension -ne ""){
            # Get Dates
            $dateCreated = ((getCreationTime -path $_.FullName).split(' ')[2]).split('/');
            $month = $dateCreated[0];
            $day = $dateCreated[1];
            $year = $dateCreated[2];

            # Output String to Console (if true)
            if($DisplayOutput){
                $strOut = "";
                $strOut += $_.Name;
                $strOut += " Found! --> "
                $strOut += "$month/$day/$year";
                Write-Output $strOut;
            }

            # Do Something to the FOUND file with DATE CREATED
            $dateDir, $created = createDateDir -yr $year -day $day;    # Create the Date Directory | Get Path
            Write-Output $created; # Output that Directory Created
            
            if($NoDamage){ Copy-Item $_.FullName $dateDir; }
            else { Move-Item $_.FullName $dateDir; }


            # Keep Track of these Data
            $global:total++;
        }
    }
}


# Adjusts Given Paths to make sure there is the absolute paths if needed
function resolvePaths() {
    # Check if Extention Parameter Given (Required)
    if(!$extMatch) {
        Write-Error "No extention parameter given!"
        return;
    }

    # Make sure SearchDir Exist (Required)
    if(!(Test-Path -Path $SearchDir)){
        Write-Error "Search Directory Does not exist!"
        return;
    }

    # Create Output path if non Exist (Optional)
    if(!(Test-Path -Path $OutputDir)){
        Write-Output "Output Directory does not exits, directory path '$OutputDir' created!"
        New-Item -ItemType Directory -Path $OutputDir | Out-Null;
    }

    # Get the Full Paths
    $SearchDir = Resolve-Path -Path $SearchDir;
    $OutputDir = Resolve-Path -Path $OutputDir;

    # Start the Search & Copy/Move
    searchDir -dir $SearchDir

    # Output Done to Console
    Write-Output "Done! Found = $total";
}

# Returns Entire MetaData as Object
# NOT USED (Maybe in the future??)
function getMetaData($path) {
    return Get-ItemProperty -Path $path | Format-List -Property *;
}

# Returns The CreationTime MetaData as String
function getCreationTime($path) {
    $data = Get-ItemProperty -Path $path | Format-List -Property CreationTime | Out-String;
    $time = "";
    $str = "";

    # Break Up Data Gathered and find time
    for($x=0; $x -lt $data.Length; $x++) {
        if($data[$x] -match '\n') {
            # Make sure str has data in in it
            if($str.Length -ne 1){
                $time = $str;
                break; # End Loop
            }

            # Clear out str
            $str = "";
        }
        
        else {
            $str += $data[$x];
        }
    }

    return $time;
}

# Checks and Creates a Date Directory for Year/Month Directory
# Returns Full path to the directory
function createDateDir($yr, $day) {
    # Create Full Path as Variable
    $newPath = Convert-Path $OutputDir;
    $newPath += "\$yr\$day";

    # Check if path exists
    if(!(Test-Path -Path $newPath)) {
        New-Item -ItemType Directory -Path $newPath | Out-Null; # No Output
        $dirCreated = "Directory $yr\$day Created!";
    }

    # Return Full new Path
    return $newPath, $dirCreated;
}


resolvePaths