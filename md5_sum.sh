#!/bin/bash

# Prompt the user to enter the filename
read -p "Enter the name of the file: " filename

# Calculate the MD5 hash of the file
md5=$(md5sum "${filename}" | awk '{ print $1 }')

# Output the result
echo "The MD5 hash of ${filename} is: ${md5}"
