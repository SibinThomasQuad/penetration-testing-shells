#!/bin/bash

# Read in the list of domains from a file
read -p "Enter the path to the file containing the list of domains: " domain_file

# Loop through each domain in the file
while read domain; do
    # Use the ping command to check if the domain is live
    ping -c 1 "${domain}" > /dev/null
    
    # Check the return code of the ping command
    if [ $? -eq 0 ]; then
        echo "${domain} is live"
    else
        echo "${domain} is not reachable"
    fi
done < "${domain_file}"
