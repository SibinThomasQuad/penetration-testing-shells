#!/bin/bash

# ANSI color codes
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"  # No color

# Function to search files containing specific contents
search_files_with_contents() {
    local contents=("$@")
    shift
    find "$@" -type f -exec grep -l "${contents[@]}" {} +
}

# Function to search files using MD5 checksum
search_files_with_md5() {
    local md5_checksum="$1"
    shift
    find "$@" -type f -exec md5sum {} + | grep "$md5_checksum" | awk '{print $2}'
}

# Function to search files using SHA-1 checksum
search_files_with_sha1() {
    local sha1_checksum="$1"
    shift
    find "$@" -type f -exec sha1sum {} + | grep "$sha1_checksum" | awk '{print $2}'
}

# Function to search files with hexadecimal content pattern
search_files_with_hex() {
    local hex_pattern="$1"
    shift
    hex_pattern=$(echo "$hex_pattern" | sed 's/ //g')  # Remove spaces
    find "$@" -type f -exec xxd -p {} + | grep "$hex_pattern" | awk -F ':' '{print $1}' | xargs -I % sh -c 'echo "%" | xxd -r -p'
}

# Function to get hexadecimal content pattern of a file
get_hex_pattern_of_file() {
    local file="$1"
    xxd -p "$file" | tr -d '\n'
}

# Function to get MD5 checksum of a file
get_md5_checksum_of_file() {
    local file="$1"
    md5sum "$file" | awk '{print $1}'
}

# Function to get SHA-1 checksum of a file
get_sha1_checksum_of_file() {
    local file="$1"
    sha1sum "$file" | awk '{print $1}'
}

# Function to search files with specific extensions
search_files_with_extensions() {
    local extensions=("${@:1:$#-1}")
    local start_dir="${@:$#}"
    find "$start_dir" -type f \( -name "*.${extensions[@]}" \) -exec ls -l {} \;
}

# Function to identify URLs in files
identify_urls_in_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        urls=($(grep -oP '(?<=http://|https://|ftp://|www\.)[a-zA-Z0-9./?%&=_-]+' "$file"))
        for url in "${urls[@]}"; do
            printf "${RED}%s${NC} : ${GREEN}%s${NC}\n" "$url" "$file"
        done
    done
}

# Function to identify IP addresses in files
identify_ip_addresses_in_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        ip_addresses=($(grep -oP '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b' "$file"))
        for ip in "${ip_addresses[@]}"; do
            printf "${RED}%s${NC} : ${GREEN}%s${NC}\n" "$ip" "$file"
        done
    done
}

# Function to identify email addresses in files
identify_emails_in_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        emails=($(grep -oP '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}' "$file"))
        for email in "${emails[@]}"; do
            printf "${RED}%s${NC} : ${GREEN}%s${NC}\n" "$email" "$file"
        done
    done
}

# Function to search for specific content pattern and show line numbers
search_files_for_content_pattern() {
    local content_pattern="$1"
    shift
    find "$@" -type f -exec grep -n "${content_pattern}" {} +
}

# Function to replace text in all files
replace_text_in_files() {
    local search_text="$1"
    local replace_text="$2"
    local files=("${@:3}")
    
    for file in "${files[@]}"; do
        sed -i "s/$search_text/$replace_text/g" "$file"
        printf "Replaced ${RED}%s${NC} with ${GREEN}%s${NC} in ${GREEN}%s${NC}\n" "$search_text" "$replace_text" "$file"
    done
}

# Function to identify malfunctioned PHP files
identify_malfunctioned_php_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        php -l "$file" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "${RED}Malfunctioned PHP file: ${GREEN}$file${NC}"
        fi
    done
}

# Function to identify malfunctioned Python files
identify_malfunctioned_python_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        python3 -m py_compile "$file" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "${RED}Malfunctioned Python file: ${GREEN}$file${NC}"
        fi
    done
}

# Function to identify malfunctioned shell scripts
identify_malfunctioned_shell_scripts() {
    local files=("$@")
    for file in "${files[@]}"; do
        shellcheck "$file" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "${RED}Malfunctioned shell script: ${GREEN}$file${NC}"
        fi
    done
}

# Function to identify malfunctioned batch files
identify_malfunctioned_batch_files() {
    local files=("$@")
    for file in "${files[@]}"; do
        cmd /c "chcp 65001>nul && echo off && for %x in (\"$file\") do @echo %~nx" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "${RED}Malfunctioned batch file: ${GREEN}$file${NC}"
        fi
    done
}

# Function to identify write permission folders and files
identify_write_permission() {
    local files=("$@")
    for file in "${files[@]}"; do
        if [ -w "$file" ]; then
            echo -e "${RED}Write permission granted: ${GREEN}$file${NC}"
        fi
    done
}

# Main menu
while true; do
    echo "Select an option:"
    echo "1. Search files with specific contents"
    echo "2. Search files using MD5 checksum"
    echo "3. Search files using SHA-1 checksum"
    echo "4. Search files using hexadecimal pattern"
    echo "5. Get hexadecimal pattern of a file"
    echo "6. Get MD5 checksum of a file"
    echo "7. Get SHA-1 checksum of a file"
    echo "8. Search files with specific extensions"
    echo "9. Identify URLs in files"
    echo "10. Identify IP addresses in files"
    echo "11. Identify email addresses in files"
    echo "12. Search for content pattern with line numbers"
    echo "13. Replace text in files"
    echo "14. Identify malfunctioned PHP files"
    echo "15. Identify malfunctioned Python files"
    echo "16. Identify malfunctioned shell scripts"
    echo "17. Identify malfunctioned batch files"
    echo "18. Identify write permission folders and files"
    echo "19. Identify write permission files"
    echo "20. Quit"
    read -p "Enter your choice: " choice

    case "$choice" in
        1)
            read -p "Enter the content pattern to search: " content_pattern
            read -p "Enter the directory to start the search from: " start_dir
            result_files=($(search_files_with_contents "${content_pattern}" "$start_dir"))

            echo -e "Files with content ${RED}${content_pattern}${NC} in ${GREEN}$start_dir${NC}:"
            for file in "${result_files[@]}"; do
                echo -e "${GREEN}$file${NC}"
            done
            ;;
        2)
            read -p "Enter the MD5 checksum to search: " md5_checksum
            read -p "Enter the directory to start the search from: " start_dir
            result_files=($(search_files_with_md5 "${md5_checksum}" "$start_dir"))

            echo -e "Files with MD5 checksum ${RED}${md5_checksum}${NC} in ${GREEN}$start_dir${NC}:"
            for file in "${result_files[@]}"; do
                echo -e "${GREEN}$file${NC}"
            done
            ;;
        3)
            read -p "Enter the SHA-1 checksum to search: " sha1_checksum
            read -p "Enter the directory to start the search from: " start_dir
            result_files=($(search_files_with_sha1 "${sha1_checksum}" "$start_dir"))

            echo -e "Files with SHA-1 checksum ${RED}${sha1_checksum}${NC} in ${GREEN}$start_dir${NC}:"
            for file in "${result_files[@]}"; do
                echo -e "${GREEN}$file${NC}"
            done
            ;;
        4)
            read -p "Enter the hexadecimal pattern to search: " hex_pattern
            read -p "Enter the directory to start the search from: " start_dir
            result_files=($(search_files_with_hex "${hex_pattern}" "$start_dir"))

            echo -e "Files with hexadecimal pattern ${RED}${hex_pattern}${NC} in ${GREEN}$start_dir${NC}:"
            for file in "${result_files[@]}"; do
                echo -e "${GREEN}$file${NC}"
            done
            ;;
        5)
            read -p "Enter the path of the file: " file_path
            hex_pattern=$(get_hex_pattern_of_file "${file_path}")
            echo -e "Hexadecimal pattern of ${GREEN}${file_path}${NC}:"
            echo -e "${RED}${hex_pattern}${NC}"
            ;;
        6)
            read -p "Enter the path of the file: " file_path
            md5_checksum=$(get_md5_checksum_of_file "${file_path}")
            echo -e "MD5 checksum of ${GREEN}${file_path}${NC}:"
            echo -e "${RED}${md5_checksum}${NC}"
            ;;
        7)
            read -p "Enter the path of the file: " file_path
            sha1_checksum=$(get_sha1_checksum_of_file "${file_path}")
            echo -e "SHA-1 checksum of ${GREEN}${file_path}${NC}:"
            echo -e "${RED}${sha1_checksum}${NC}"
            ;;
        8)
            read -p "Enter the extensions separated by spaces: " extensions
            read -p "Enter the directory to start the search from: " start_dir
            result_files=($(search_files_with_extensions "${extensions}" "$start_dir"))

            echo -e "Files with extensions ${RED}${extensions}${NC} in ${GREEN}$start_dir${NC}:"
            for file in "${result_files[@]}"; do
                echo -e "${GREEN}$file${NC}"
            done
            ;;
        9)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f))
            identify_urls_in_files "${files_to_search[@]}"
            ;;
        10)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f))
            identify_ip_addresses_in_files "${files_to_search[@]}"
            ;;
        11)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f))
            identify_emails_in_files "${files_to_search[@]}"
            ;;
        12)
            read -p "Enter the content pattern to search: " content_pattern
            read -p "Enter the directory to start the search from: " start_dir
            result_files=($(search_files_for_content_pattern "${content_pattern}" "$start_dir"))

            echo -e "Files with content pattern ${RED}${content_pattern}${NC} in ${GREEN}$start_dir${NC}:"
            for file in "${result_files[@]}"; do
                echo -e "${GREEN}$file${NC}"
            done
            ;;
        13)
            read -p "Enter the text to search: " search_text
            read -p "Enter the text to replace with: " replace_text
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f))
            replace_text_in_files "$search_text" "$replace_text" "${files_to_search[@]}"
            ;;
        14)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f -name "*.php"))
            identify_malfunctioned_php_files "${files_to_search[@]}"
            ;;
        15)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f -name "*.py"))
            identify_malfunctioned_python_files "${files_to_search[@]}"
            ;;
        16)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f -name "*.sh"))
            identify_malfunctioned_shell_scripts "${files_to_search[@]}"
            ;;
        17)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f -name "*.bat"))
            identify_malfunctioned_batch_files "${files_to_search[@]}"
            ;;
        18)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type d))
            identify_write_permission "${files_to_search[@]}"
            ;;
        19)
            read -p "Enter the directory to start the search from: " start_dir
            files_to_search=($(find "$start_dir" -type f -perm -u=w))
            identify_write_permission "${files_to_search[@]}"
            ;;
        20)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac
done
