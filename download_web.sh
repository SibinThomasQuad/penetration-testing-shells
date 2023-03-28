#!/bin/bash

echo "Enter website URL to download:"
read WEBSITE_URL

# Create a directory for the downloaded website
echo "Enter directory to save the website (default: ~/Downloads):"
read DOWNLOAD_DIR

if [ -z "$DOWNLOAD_DIR" ]; then
    DOWNLOAD_DIR="$HOME/Downloads"
fi

if [ ! -d "$DOWNLOAD_DIR" ]; then
    mkdir -p "$DOWNLOAD_DIR"
fi

# Download the website recursively
echo "Downloading $WEBSITE_URL to $DOWNLOAD_DIR ..."
wget \
    --recursive \
    --no-clobber \
    --page-requisites \
    --html-extension \
    --convert-links \
    --restrict-file-names=windows \
    --no-parent \
    --directory-prefix="$DOWNLOAD_DIR" \
    "$WEBSITE_URL"
