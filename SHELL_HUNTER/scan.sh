#!/bin/bash

# Function to scan files for the given string and print matching file names
function scan_files_for_string {
    local search_string="$1"
    local root_folder="$2"
    local red="\033[31m"
    local reset="\033[0m"

    # Loop through all files in the root folder and its subdirectories
    find "$root_folder" -type f | while read -r file; do
        if grep -qF "$search_string" "$file"; then
            echo -e "${red}Found in: $file${reset}"
        fi
    done
}

# Function to check folder permissions
function check_folder_permissions {
    local root_folder="$1"
    local red="\033[31m"
    local reset="\033[0m"

    # Loop through all folders in the root folder and its subdirectories
    find "$root_folder" -type d | while read -r folder; do
        permissions=$(stat -c "%a %n" "$folder")
        echo -e "${red}Folder: $permissions${reset}"
    done
}

# Function to check enabled PHP modules and identify malfunctioned PHP codes
function check_enabled_php_modules {
    local red="\033[31m"
    local reset="\033[0m"

    echo -e "${red}Enabled PHP modules:${reset}"
    php -m
    echo

    # Check PHP syntax errors in PHP files
    echo -e "${red}Checking for PHP syntax errors...${reset}"
    find . -type f -name "*.php" | while read -r file; do
        if ! php -l "$file"; then
            echo -e "${red}Syntax error in: $file${reset}"
        fi
    done
}

# Function to check for blacklisted patterns in PHP files
function check_blacklist {
    local root_folder="$1"
    local blacklist_file="blacklist.txt"
    local red="\033[31m"
    local reset="\033[0m"

    # Loop through all PHP files in the root folder and its subdirectories
    find "$root_folder" -type f -name "*.php" | while read -r file; do
        # Check if the file contains any blacklisted patterns
        while IFS= read -r pattern; do
            if grep -qF "$pattern" "$file"; then
                echo -e "${red}Potentially malicious file: $file (Contains blacklisted pattern: $pattern)${reset}"
                break
            fi
        done < "$blacklist_file"
    done
}

# Function to check for blacklisted patterns in Python files
function check_python_blacklist {
    local root_folder="$1"
    local python_blacklist_file="python_blacklist.txt"
    local red="\033[31m"
    local reset="\033[0m"

    # Loop through all Python files in the root folder and its subdirectories
    find "$root_folder" -type f -name "*.py" | while read -r file; do
        # Check if the file contains any blacklisted patterns
        while IFS= read -r pattern; do
            if grep -qF "$pattern" "$file"; then
                echo -e "${red}Potentially malicious Python file: $file (Contains blacklisted pattern: $pattern)${reset}"
                break
            fi
        done < "$python_blacklist_file"
    done
}

# Function to check for blacklisted file extensions
function check_blacklisted_extensions {
    local root_folder="$1"
    local blacklist_extensions_file="blacklisted_extensions.txt"
    local red="\033[31m"
    local reset="\033[0m"

    # Loop through all files in the root folder and its subdirectories
    find "$root_folder" -type f | while read -r file; do
        # Extract the file extension
        extension="${file##*.}"
        
        # Check if the file extension is in the blacklist
        if grep -qF "$extension" "$blacklist_extensions_file"; then
            echo -e "${red}Potentially suspicious file: $file (Blacklisted extension: .$extension)${reset}"
        fi
    done
}

# Function to check open ports
function check_open_ports {
    echo "Open ports:"
    netstat -tuln
    echo
}

# Main menu
while true; do
    echo "Main Menu:"
    echo "1. Scan for patterns in files"
    echo "2. Check folder permissions"
    echo "3. Check enabled PHP modules and identify malfunctioned PHP codes"
    echo "4. Check for potentially malicious PHP files"
    echo "5. Check for potentially malicious Python files"
    echo "6. Check for potentially suspicious files based on blacklisted extensions"
    echo "7. Exit"
    read -p "Enter your choice (1/2/3/4/5/6/7): " choice

    case "$choice" in
        1)
            # Input the root folder
            read -p "Enter the root folder: " root_folder

            # Input the string to search for
            read -p "Enter the string to search for: " search_string

            # Call the function to scan files for the string and the root folder
            echo "Scanning for pattern: $search_string"
            scan_files_for_string "$search_string" "$root_folder"
            echo
            ;;
        2)
            # Input the root folder
            read -p "Enter the root folder: " root_folder

            # Call the function to check folder permissions for the root folder
            echo "Checking folder permissions..."
            check_folder_permissions "$root_folder"
            echo
            ;;
        3)
            # Call the function to check enabled PHP modules and identify malfunctioned PHP codes
            check_enabled_php_modules
            ;;
        4)
            # Input the root folder
            read -p "Enter the root folder: " root_folder

            # Call the function to check for potentially malicious PHP files
            echo "Checking for potentially malicious PHP files..."
            check_blacklist "$root_folder"
            echo
            ;;
        5)
            # Input the root folder
            read -p "Enter the root folder: " root_folder

            # Call the function to check for potentially malicious Python files
            echo "Checking for potentially malicious Python files..."
            check_python_blacklist "$root_folder"
            echo
            ;;
        6)
            # Input the root folder
            read -p "Enter the root folder: " root_folder

            # Call the function to check for potentially suspicious files based on blacklisted extensions
            echo "Checking for potentially suspicious files based on blacklisted extensions..."
            check_blacklisted_extensions "$root_folder"
            echo
            ;;
        7)
            # Exit the script
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select 1, 2, 3, 4, 5, 6, or 7."
            ;;
    esac
done
