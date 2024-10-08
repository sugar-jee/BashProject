#!/bin/bash

### INSTRUCTIONS FOR USING SCRIPT ###

# Function to display script usage/help information
function display_usage() {
  # hint: you will have multiple echo statements here
  echo ""
  echo "Usage: $0 <-f/-d> <file/directory name> <-p/-l> <file/directory permissions>"
  echo "Options:"
  echo "  -f <filename>: Specify an existing file/Create a new file."
  echo "  -p <filepermissions>: Specify the file permissions. Format: ###"
  echo "  -d <directoryname>: Specify an existing directory/Create a new directory."
  echo "  -l <directorypermissions>: Specify the directory permissions. Format: ###"
  echo "  -c <filename or directoryname>: Specify an existing file or directory to check the permissions of."
  echo "  -h: Display this help information."
  echo ""
  echo "Note: Format permissions as '###'."
  echo ""
}

### SETTING VARIABLES ###

#Initialize variables
filename=""
directoryname=""
filepermissions=""
directorypermissions=""
check=""

#Initialize switch variables - tracks which options have been provided, allows for customized error messages further below.
filename_switch=false
filepermissions_switch=false
directoryname_switch=false
directorypermssions_switch=false
check_switch=false

### CHECKING THE SWITCHES ###

#Take note of which command-line options and arguments are used
while getopts "f:p:d:l:ch" opt; do
    case $opt in
        # option f - will look for the specified file and create one if not found.
        f)
            filename="$OPTARG"
            filename_switch=true
            
            ;;

        # option fp - confirm if file permissions were specified. 
        p)
            filepermissions="$OPTARG"
            filepermissions_switch=true
            ;;

        # option d - will look for the specified directory and create one if not found.
        d)
            directoryname="$OPTARG"
            directoryname_switch=true
            ;;

        # option dp - confirm if directory permissions were specified.
        l)
            directorypermissions=${OPTARG}
            directorypermissions_switch=true
            ;;

        # option c - check & print the current permissions of the specified file/directory.
        c)
            check=${OPTARG}
            check_switch=true
            ;;

        # option h - display usage
        h)
            display_usage
            exit 1
            ;;

        # any other option
        \?)
            echo "Invalid option: -$OPTARG"
            display_usage
            exit 1
            ;;

        # no argument
        :)
            echo "Option -$OPTARG requires an argument."
            display_usage
            exit 1
            ;;
    esac
done

### PROCESS POSSIBLE CHECK ###

# Has Filename and Check
if [[ "$filename_switch" == true && "$check_switch" == true ]]; then
    if [ -e "$filename" ]; then
        permissions=$(stat -c "%A" $filename)
        echo "The permissions of $filename are $permissions."
        exit 1
    else
        echo "File does not exist."
        display_usage
        exit 1
    # exit
    fi
fi

# Has Directoryname and Check
if [[ "$directoryname_switch" == true && "$check_switch" == true ]]; then
    if [ -d "$directoryname" ]; then
        permissions=$(stat -c "%A" $directoryname)
        echo "The permissions of $directoryname are $permissions."
        exit 1
    else
        echo "File does not exist."
        display_usage
        exit 1
    # exit
    fi
fi


### ERROR MESSAGES ###

# Check if no arguments are provided, provide usage and exit.
if [[ $OPTIND -eq 1 ]]; then
    display_usage
    exit 1
    # exit
fi

# Has FileName but no FilePermissions
if [[ "$filename_switch" == true && "$filepermissions_switch" == false ]]; then
    echo "ERROR: File name provided without file permissions."
    display_usage
    exit 1
    # exit
fi

# Has DirectoryName but no DirectoryPermissions
if [[ "$directoryname_switch" == true && "$directorypermissions_switch" == false ]]; then
    echo "ERROR: Directory name provided without directory permissions."
    display_usage
    exit 1
    # exit
fi

# Has FilePermisssions but no FileName
if [[ "$filepermissions_switch" == true && "$filename_switch" == false ]]; then
    echo "ERROR: File permissions provided without file name. If the file doesn't already exist, the file will be created."
    display_usage
    exit 1
    # exit
fi

# Has DirectoryPermissions but no DirectoryName
if [[ "$directorypermissions_switch" == true && "$directoryname_switch" == false ]]; then
    echo "ERROR: Directory permissions without directory name. If the directory doesn't already exist, the directory will be created."
    display_usage
    exit 1
    # exit
fi

## CHANGING PERMISSIONS ###

#If both filename and filepermissions are specified, apply permissions.
if [[ "$filepermissions_switch" == true && "$filename_switch" == true ]]; then
    if [ -e "$filename" ]; then
        permissions=$(stat -c "%A" $filename)
        echo "File '$filename' found."
        echo "Current permissions: $permissions"
    else
        touch "$filename"
        permissions=$(stat -c "%A" $filename)
        echo "File '$filename' created."
        echo "Default permissions: $permissions"
    fi
    chmod "$filepermissions" "$filename"
    # echo $? #check chmod worked, 0=worked
    newpermissions=$(stat -c "%A" $filename)
    echo "Permissions of file '$filename' are now '$newpermissions'."
fi

#If both directoryname and directorypermissions are specified, apply permissions.
if [[ "$directorypermissions_switch" == true && "$directoryname_switch" == true ]]; then
    if [ -d "$directoryname" ]; then
        permissions=$(stat -c "%A" $directoryname)
        echo "Directory '$directoryname' found." 
    else
        permissions=$(stat -c "%A" $directoryname)
        mkdir "$directoryname"
        echo "Directory '$directoryname' created." 
        echo "Default permissions: " $permissions
    fi
    chmod "$directorypermissions" "$directoryname"
    # echo $? #check chmod worked, 0=worked
    newpermissions=$(stat -c "%A" $directoryname)
    echo "Permissions of directory '$directoryname' are now '$newpermissions'."
fi