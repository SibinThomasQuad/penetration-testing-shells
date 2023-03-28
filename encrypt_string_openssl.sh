#!/bin/bash

echo "Enter string to encrypt:"
read -s PLAINTEXT

echo "Enter passphrase:"
read -s PASSPHRASE

# Encrypt the string
ENCRYPTED=$(echo "$PLAINTEXT" | openssl enc -aes-256-cbc -a -salt -pass pass:"$PASSPHRASE")

echo "String encrypted as: $ENCRYPTED"

echo "Enter string to decrypt:"
read -s ENCRYPTED_STRING

echo "Enter passphrase:"
read -s DECRYPT_PASSPHRASE

# Decrypt the string
DECRYPTED=$(echo "$ENCRYPTED_STRING" | openssl enc -d -aes-256-cbc -a -pass pass:"$DECRYPT_PASSPHRASE")

echo "String decrypted as: $DECRYPTED"
