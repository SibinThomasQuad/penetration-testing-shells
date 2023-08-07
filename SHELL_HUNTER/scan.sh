#!/bin/bash

# Function to scan files for the given string and print matching file names
function scan_files_for_string {
    local search_string="$1"
    local root_folder="$2"
    local red="\033[31m"
    local reset="\033[0m"

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
    local php_blacklist_file="php_blacklist.txt"
    local red="\033[31m"
    local reset="\033[0m"

    find "$root_folder" -type f -name "*.php" | while read -r file; do
        while IFS= read -r pattern; do
            if grep -qF "$pattern" "$file"; then
                echo -e "${red}Potentially malicious file: $file (Contains blacklisted pattern: $pattern)${reset}"
                break
            fi
        done < "$php_blacklist_file"
    done
}

# Function to check for blacklisted patterns in Python files
function check_python_blacklist {
    local root_folder="$1"
    local python_blacklist_file="python_blacklist.txt"
    local red="\033[31m"
    local reset="\033[0m"

    find "$root_folder" -type f -name "*.py" | while read -r file; do
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

    find "$root_folder" -type f | while read -r file; do
        extension="${file##*.}"
        
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

# Function to scan files based on hash sum saved in a file list using MD5
function scan_files_by_hash_md5 {
    local hash_file="$1"
    local root_folder="$2"
    local red="\033[31m"
    local reset="\033[0m"

    while IFS= read -r hash_line; do
        hash_value="${hash_line%% *}"
        file_path="${hash_line#* }"

        calculated_hash=$(md5sum "$root_folder/$file_path" | awk '{print $1}')

        if [ "$hash_value" == "$calculated_hash" ]; then
            echo -e "${red}Hash matched: $root_folder/$file_path${reset}"
        fi
    done < "$hash_file"
}

# Function to calculate the MD5 hash of a file
function calculate_md5_hash {
    local file_path="$1"
    local red="\033[31m"
    local reset="\033[0m"

    if [ -f "$file_path" ]; then
        md5_hash=$(md5sum "$file_path" | awk '{print $1}')
        echo -e "${red}MD5 Hash of $file_path: $md5_hash${reset}"
    else
        echo -e "${red}File not found: $file_path${reset}"
    fi
}

# Main menu
while true; do
    echo "------------------------------------------------------------------------------------"
    echo ""
    echo "FIL3-HUNT3R"
    echo ""
    echo "------------------------------------------------------------------------------------"
    echo "Main Menu:"
    echo "1. Scan for patterns in files"
    echo "2. Check folder permissions"
    echo "3. Check enabled PHP modules and identify malfunctioned PHP codes"
    echo "4. Check for potentially malicious PHP files"
    echo "5. Check for potentially malicious Python files"
    echo "6. Check for potentially suspicious files based on blacklisted extensions"
    echo "7. Scan files based on hash sum saved in file list (using MD5)"
    echo "8. Calculate MD5 hash of a file"
    echo "9. Clear Screen"
    echo "10. Exit"
    read -p "Enter your choice (1/2/3/4/5/6/7/8/9/10): " choice

    case "$choice" in
        1)
            read -p "Enter the root folder: " root_folder
            read -p "Enter the string to search for: " search_string
            echo "Scanning for pattern: $search_string"
            scan_files_for_string "$search_string" "$root_folder"
            echo
            ;;
        2)
            read -p "Enter the root folder: " root_folder
            echo "Checking folder permissions..."
            check_folder_permissions "$root_folder"
            echo
            ;;
        3)
            check_enabled_php_modules
            ;;
        4)
            read -p "Enter the root folder: " root_folder
            echo "Checking for potentially malicious PHP files..."
            check_blacklist "$root_folder"
            echo
            ;;
        5)
            read -p "Enter the root folder: " root_folder
            echo "Checking for potentially malicious Python files..."
            check_python_blacklist "$root_folder"
            echo
            ;;
        6)
            read -p "Enter the root folder: " root_folder
            echo "Checking for potentially suspicious files based on blacklisted extensions..."
            check_blacklisted_extensions "$root_folder"
            echo
            ;;
        7)
            read -p "Enter the hash file: " hash_file
            read -p "Enter the root folder: " root_folder
            echo "Scanning files based on hash sum (using MD5)..."
            scan_files_by_hash_md5 "$hash_file" "$root_folder"
            echo
            ;;
        8)
            read -p "Enter the file path: " file_path
            calculate_md5_hash "$file_path"
            echo
            ;;
        9)
            clear  # Clear the screen
            ;;
        10)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
