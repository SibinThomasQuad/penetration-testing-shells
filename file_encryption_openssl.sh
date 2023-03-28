#!/bin/bash

echo "Enter file name to encrypt:"
read FILENAME

echo "Enter passphrase:"
read -s PASSPHRASE

# Encrypt the file
openssl aes-256-cbc -a -salt -in $FILENAME -out $FILENAME.enc -pass pass:"$PASSPHRASE"

echo "File encrypted as $FILENAME.enc"

echo "Enter file name to decrypt:"
read DECRYPT_FILE

echo "Enter passphrase:"
read -s DECRYPT_PASSPHRASE

# Decrypt the file
openssl aes-256-cbc -d -a -in $DECRYPT_FILE -out decrypted.txt -pass pass:"$DECRYPT_PASSPHRASE"

echo "File decrypted as decrypted.txt"
