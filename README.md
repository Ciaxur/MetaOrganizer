# MetaOrganizer

**Simple Powershell Script that organizes an input directory to an output directory based on the file extensions' Creation Date.**

---

# How to Use

You need to know basic Powershell concepts such as how to change directory, run scripts (allow scripts to be executed), and how to pass parameters into a script. I will display as much information below:

``` powershell
# Make sure this is this project is the current working directory
# Copy Testing Contents into 'src' directory from 'test' directory
Copy-Item -Recurse ./test/** ./src

# Change Directory into the 'src' directory
cd ./src

# Make sure to set execution policy to bypass, if needed. (Requires Administrator Privileges)
Set-ExecutionPolicy Bypass

# Execute the Script using it's default parameters to look for all files that are .txt or .jpg
# For more information on the Parameters, look at the "More About the Script" section of README.md
./Script.ps1 -extMatch "(.txt|.jpg)"

# Now you should have an "Out" directory with a Directory indicating the Year/Month of files created
```

---
# More About the Script

### `Required Parameters`
- **extMatch**
    - **`Type`**: String
    - **`Description`**: The Extension that will be searched for (RegEx)

### `Optional Parameters`
- **SearchDir**
    - **`Type`**: String
    - **`Default`**: Current Directory `./`
    - **`Description`**: The Directory that will be searched through for extention match

- **OutputDir**
    - **`Type`**: String
    - **`Default`**: 'Out' Directory `./Out`
    - **`Description`**: The Output Directory for the files that match given extention parameter. Output directory created if not found

- **NoDamage**
    - **`Type`**: Switch
    - **`Default`**: False / Off
    - **`Description`**: Enables Coping the items instead of Moving them thus creating "No Damage" to current files

- **DisplayOutput**
    - **`Type`**: Switch
    - **`Default`**: False / Off
    - **`Description`**: Enables displaying more detailed output to console


---
# Contribution
Contributing is very simple, keep directories exactly the same. Add or fix functionallity to the script and submit a Pull Request :)


---
# License
Licensed under the [MIT License](LICENSE.md).