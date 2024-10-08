#check permissions of files directory
permissions=$(stat -c "%A" "test4.txt")

# Display the file permissions
echo "File permissions: $permissions"