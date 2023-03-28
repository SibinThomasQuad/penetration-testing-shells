#!/bin/bash

echo "Enter target URL:"
read URL

echo "Enter path to wordlist:"
read WORDLIST

while read word; do
    status=$(curl -s -o /dev/null -w "%{http_code}" $URL/$word/)
    if [ $status -eq 200 ]; then
        echo "Directory found: $URL/$word/"
    fi
done < $WORDLIST
