#!/bin/bash

# Function to extract IP addresses from a text file
extract_ip_addresses() {
    local file_path="$1"
    local ip_pattern="\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"
    local ip_addresses=()
    
    while IFS= read -r line; do
        ip_matches=$(echo "$line" | grep -oE "$ip_pattern")
        if [ -n "$ip_matches" ]; then
            ip_addresses+=("$ip_matches")
        fi
    done < "$file_path"
    
    echo "${ip_addresses[@]}"
}

# Function to get the location details of an IP address
get_ip_location() {
    local ip_address="$1"
    local url="https://ipinfo.io/$ip_address/json"
    local response
    response=$(curl -s "$url")

    local ip city region country
    if [ "$(echo "$response" | jq -r '.ip')" != "null" ]; then
        ip=$(echo "$response" | jq -r '.ip')
        city=$(echo "$response" | jq -r '.city // "N/A"')
        region=$(echo "$response" | jq -r '.region // "N/A"')
        country=$(echo "$response" | jq -r '.country // "N/A"')
    else
        ip="$ip_address"
        city="N/A"
        region="N/A"
        country="N/A"
    fi
    
    echo "$ip - Location: $city, $region, $country"
}

# Main function
main() {
    read -p "Choose an option:
    1. Process a single file
    2. Process all files in a folder
    Enter 1 or 2: " choice

    if [ "$choice" = "1" ]; then
        read -p "Enter the path to the file: " file_path
        output_file="output.log"  # Output file in the current directory
        process_file "$file_path" "$output_file"
    elif [ "$choice" = "2" ]; then
        read -p "Enter the path to the folder: " folder_path
        output_file="output.log"  # Output file in the current directory
        process_folder "$folder_path" "$output_file"
    else
        echo "Invalid choice. Please enter 1 or 2."
    fi
}

# Function to process a single file
process_file() {
    local file_path="$1"
    local output_file="$2"

    if [ ! -f "$file_path" ]; then
        echo "'$file_path' is not a valid file."
        return
    fi

    ip_addresses=($(extract_ip_addresses "$file_path"))
    if [ ${#ip_addresses[@]} -eq 0 ]; then
        echo "No IP addresses found in the file."
        return
    fi

    declare -A unique_ips

    while IFS= read -r ip_address; do
        if [ -z "${unique_ips[$ip_address]}" ]; then
            unique_ips["$ip_address"]=1
            location=$(get_ip_location "$ip_address")
            echo "$location"
            echo "$location" >> "$output_file"
        fi
    done <<< "${ip_addresses[@]}"
}

# Function to process all files in a folder
process_folder() {
    local folder_path="$1"
    local output_file="$2"

    if [ ! -d "$folder_path" ]; then
        echo "'$folder_path' is not a valid folder."
        return
    fi

    while IFS= read -r -d '' file_path; do
        echo "Processing file: $file_path"
        echo "Processing file: $file_path" >> "$output_file"
        process_file "$file_path" "$output_file"
    done < <(find "$folder_path" -type f -print0)
}

main
