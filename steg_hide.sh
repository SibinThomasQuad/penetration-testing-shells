#!/bin/bash

# Function to encrypt a file with a passphrase
function encrypt_file {
    local file="$1"
    local passphrase="$2"
    openssl aes-256-cbc -salt -in "${file}" -out "${file}.encrypted" -pass pass:"${passphrase}"
    rm "${file}"
}

# Function to decrypt a file with a passphrase
function decrypt_file {
    local file="$1"
    local passphrase="$2"
    openssl aes-256-cbc -d -salt -in "${file}" -out "${file%.*}" -pass pass:"${passphrase}"
}

# Check if the user wants to hide or extract data
read -p "Do you want to hide or extract data? (hide/extract): " action

if [[ "${action}" == "hide" ]]; then
    # Get the user's input
    read -p "Enter the name of the file to hide data in: " cover_file
    read -p "Enter the name of the file to hide: " secret_file
    read -p "Enter a passphrase for the hidden data: " passphrase

    # Encrypt the secret file using the passphrase
    encrypt_file "${secret_file}" "${passphrase}"

    # Hide the encrypted secret file in the cover file
    steghide embed -ef "${secret_file}.encrypted" -cf "${cover_file}" -p "${passphrase}"

    echo "Data successfully hidden in ${cover_file}."
elif [[ "${action}" == "extract" ]]; then
    # Get the user's input
    read -p "Enter the name of the file to extract data from: " stego_file
    read -p "Enter the passphrase for the hidden data: " passphrase

    # Extract the hidden data from the stego file
    steghide extract -sf "${stego_file}" -p "${passphrase}"

    # Decrypt the extracted file using the passphrase
    decrypt_file "${stego_file}.out" "${passphrase}"

    echo "Data successfully extracted and decrypted."
else
    echo "Invalid action. Please choose either 'hide' or 'extract'."
    exit 1
fi
