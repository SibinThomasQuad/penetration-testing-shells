#!/bin/bash

echo "Enter URL to scan:"
read URL

# Retrieve the web page content
WEBPAGE=$(curl -s "$URL")

# Use grep to extract all URLs
URLS=$(echo "$WEBPAGE" | grep -o -E "http(s)?://[a-zA-Z0-9./?=_-]*")

# Print the URLs found
echo "URLs found in $URL:"
echo "$URLS"
