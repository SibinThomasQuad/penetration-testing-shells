#!/bin/bash

echo "Welcome to the installation script!"

# Function to install a package
install_package() {
    echo "Installing $1..."
    sudo apt-get install -y "$1"
    echo "$1 installed successfully!"
}

# Function to ask user for installation confirmation
ask_for_install() {
    read -p "Do you want to install $1? (y/n): " choice
    case "$choice" in
      y|Y ) install_package "$1";;
      n|N ) echo "Skipping $1 installation.";;
      * ) echo "Invalid choice. Skipping $1 installation.";;
    esac
}

# Install all the tools listed
install_all_tools() {
    ask_for_install "apache2"
    ask_for_install "php"
    ask_for_install "nginx"
    ask_for_install "tor"
    ask_for_install "wireshark"
    ask_for_install "sqlmap"
    ask_for_install "nmap"
    ask_for_install "dirb"
    ask_for_install "keepass2"
    ask_for_install "hashcat"
    ask_for_install "curl"
    ask_for_install "wget"
    ask_for_install "nikto"
    ask_for_install "steghide"
    ask_for_install "xsstrike" # XSSTRIKE installation
    ask_for_install "wifite" # Wifite installation
    ask_for_install "wpscan" # Wpscan installation
    ask_for_install "john" # John the Ripper installation
}

# Display numbered menu
echo "Select the tool to install:"
printf " 1. Apache\n"
printf " 2. PHP\n"
printf " 3. Nginx\n"
printf " 4. Tor\n"
printf " 5. Wireshark\n"
printf " 6. SQLMap\n"
printf " 7. Nmap\n"
printf " 8. Dirb\n"
printf " 9. KeePass\n"
printf "10. Hashcat\n"
printf "11. Curl\n"
printf "12. Wget\n"
printf "13. Nikto\n"
printf "14. Steghide\n"
printf "15. XSSTRIKE\n"
printf "16. Wifite\n"
printf "17. Wpscan\n"
printf "18. John the Ripper\n"
printf "19. Install all tools\n"
printf " 0. Exit\n"

while true; do
    read -p "Enter your choice (0-19): " choice
    case "$choice" in
        0 ) echo "Exiting the script."; exit;;
        15 ) ask_for_install "xsstrike";; # XSSTRIKE installation
        16 ) ask_for_install "wifite";; # Wifite installation
        17 ) ask_for_install "wpscan";; # Wpscan installation
        18 ) ask_for_install "john";; # John the Ripper installation
        19 ) install_all_tools;; # Install all tools option
        [1-14] ) ask_for_install "$choice";;
        * ) echo "Invalid choice. Please select a number from 0 to 19.";;
    esac
done
