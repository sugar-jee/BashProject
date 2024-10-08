# BashProject 

# About
BashProject is an assignment for my scripting 3038C course. 
This script executes several functions:
1. Creating files and directories
2. Assigning permissions to newly created files and directories
3. Updating the permissions of existing files and directories
4. Checking the permissions of existing files and directories
 
This script is useful as it provides the user greater control and visibility into the permissions of their files and directories. This script allows the user to create a file and alter the default permissions of the newly created file or directory within the same command. It also has the extra features of altering or checking the permissions of already existing files.

# Instructions
Here are instructions for writing successful commands with this code:

Usage: 
./BashScript.sh <-f/-d> <file/directory name> <-p/-l> <file/directory permissions> <-c/-h>
Options:
-f <filename>: Specify an existing file/Create a new file.
-p <filepermissions>: Specify the file permissions. Format: ###
-d <directoryname>: Specify an existing directory/Create a new directory.
-l <directorypermissions>: Specify the directory permissions. Format: ###
-c <filename or directoryname>: Specify an existing file or directory to check the permissions of.
-h: Display this help information.

# Examples
## Creating a file/directory while assigning permissions
    File Command: ./BashScript -f file.txt -p 444
    Dirctory Command: ./BashScript -d directory -l 444
## Updating the permissions of a file or directory
    File Command: ./BashScript -f file.txt -p 646
    Dirctory Command: ./BashScript -d directory -l 646
*These are basically the same as creating a file, except you're specifying an already-existing file in the command.
## Checking the permissions of a file or directory
    Checking a file: ./BashScript.sh -f file.txt -c
    Checking a directory: ./BashScript.sh -d directory -c

# Important Notes:
1. Be sure to use the corresponding arguments for files/dictionaries and their permissions. 
Use -f and -p for files, -d and -l for directories. 
Don't use -f and -l together or -d and -p together.
2. This script is only usable in a Linux environment.
