#check permissions of files directory
permissions=$(stat -c "%A" "test.txt")

# Display the file permissions
echo "File permissions: $permissions"