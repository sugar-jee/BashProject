#!/bin/bash

# Function to display script usage/help information
function display_usage() {
  # hint: you will have multiple echo statements here
  echo "Usage: $0 <option> <filename/directoryname> <filepermissions/directory permissions>"
  echo "Options:"
  echo "  -f <filename>: Specify an existing file/Create a new file."
  echo "  -d <directoryname>: Specify an existing directory/Create a new directory."
  echo "  -p <filepermissions>: Specify the file permissions to assign in RWX format."
  echo "  -l <directorypermissions>: Specify the directory permissions to assign in RWX format."
  echo "  -h: Display this help information."
}

#Initialize variables
filename=""
directoryname=""
filepermissions=""
directorypermissions=""

#Below variables track which options have been provided, allows for customized error messages further below.
filename_switch=false
filepermissions_switch=false
directoryname_switch=false
directorypermssions_switch=false

# Process command-line options and arguments
while getopts "f:p:d:l:h" opt; do
    case $opt in
        # option f - will look for the specified file and create one if not found.
        f)
            filename="$OPTARG"
            filename_switch=true
            if [ -e "$filename" ]; then
                echo "File '$filename' found."
            else
                touch "$filename"
                permissions=$(stat -c "%A" $filename)
                echo "File '$filename' created. Permissions: $permissions"
            fi
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
            if [ -d "$directoryname" ]; then
                echo "Directory '$directoryname' found." 
            else
                mkdir "$directoryname"
                echo "Directory '$directoryname' created." 
            fi
            ;;

        # option dp - confirm if directory permissions were specified.
        l)
            directorypermissions=${OPTARG}
            directorypermissions_switch=true
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
            # display usage and exit

        # no argument
        :)
            echo "Option -$OPTARG requires an argument."
            display_usage
            exit 1
            ;;
            # display usage and exit
    esac
done

#SWITCH CHECK

# Check if no arguments are provided, provide usage and exit.
if [[ $OPTIND -eq 1 ]]; then
    display_usage
    exit 1
fi

# Check if a filename was provided with the given permissions
if [[ "$filepermissions_switch" == true && "$filename_switch" == false ]]; then
    echo "ERROR: Provide a file before inputting file permissions. If it doesn't already exist, the file will be created."
    exit 1
    # exit
fi

# Check if a directory was provided with the given permissions
if [[ "$directorypermissions_switch" == true && "$directoryname_switch" == false ]]; then
    echo "ERROR: Provide a directory before inputting directory permissions. If it doesn't already exist, the directory will be created."
    exit 1
    # exit
fi

# Check if a file permission was provided with the filename
if [[ "$filename_switch" == true && "$filepermissions_switch" == false ]]; then
    echo "ERROR: Provide file permissions with the file name."
    exit 1
    # exit
fi

# Check if a directory was provided with the given permissions
if [[ "$directoryname_switch" == true && "$directorypermissions_switch" == false ]]; then
    echo "ERROR: Provide directory permissions with the directory name."
    exit 1
    # exit
fi

#CHANGING PERMISSIONS

#If both filename and filepermissions are specified, apply permissions.
if [[ "$filepermissions_switch" == true && "$filename_switch" == true ]]; then
    chmod "$filepermissions" "$filename"
    echo $? #check chmod worked
    echo "Permissions of file '$filename' are now '$filepermissions'."
    newpermissions=$(stat -c "%A" $filename)
    echo "New permissions: $newpermissions"
fi

#If both directoryname and directorypermissions are specified, apply permissions.
if [[ "$directorypermissions_switch" == true && "$directoryname_switch" == true ]]; then
    chmod "$directorypermissions" "$directoryname"
    echo $? #check chmod worked
    echo "Permissions of directory '$directoryname' are now '$directorypermissions'."
fi