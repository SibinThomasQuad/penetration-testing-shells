#!/bin/bash

# Update package lists
sudo apt update

# Install general testing tools
sudo apt install -y nmap wireshark tcpdump netcat curl

# Install web testing tools
sudo apt install -y nikto dirb wpscan sqlmap burpsuite zaproxy skipfish

# Install network testing tools
sudo apt install -y aircrack-ng ettercap-text-only macchanger netdiscover hping3

# Install wireless testing tools
sudo apt install -y wifite reaver bully fern-wifi-cracker wifi-honey pixiewps

# Install password cracking tools
sudo apt install -y john hydra hashcat

# Install reverse engineering tools
sudo apt install -y radare2 gdb strace ltrace

# Install vulnerability scanning tools
sudo apt install -y openvas

# Install malware analysis tools
sudo apt install -y cuckoo

# Install forensic tools
sudo apt install -y sleuthkit autopsy volatility

# Install exploitation tools
sudo apt install -y metasploit-framework exploitdb

# Install social engineering tools
sudo apt install -y social-engineer-toolkit

# Install hardware hacking tools
sudo apt install -y yardstick ubertooth

# Install mobile testing tools
sudo apt install -y apktool jadx mobius

# Install wireless penetration testing tools
sudo apt install -y airgeddon pixiewps wifiphisher

# Install miscellaneous testing tools
sudo apt install -y dex2jar apktool

# Install PHP, Apache, MySQL, Nginx, and Encpad
sudo apt install -y php apache2 mysql-server nginx encpad

echo "Pentesting tools, PHP, Apache, MySQL, Nginx, and Encpad installation complete."
