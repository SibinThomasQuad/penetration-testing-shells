#!/bin/bash

# Prompt the user to enter the filename
read -p "Enter the name of the file: " filename

# Calculate the SHA-1 hash of the file
sha1=$(sha1sum "${filename}" | awk '{ print $1 }')

# Output the result
echo "The SHA-1 hash of ${filename} is: ${sha1}"
