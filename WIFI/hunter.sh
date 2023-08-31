#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Detect the Wi-Fi interface
wifi_interface=$(iw dev | grep -oP "Interface\s+\K\w+")

echo "Wi-Fi Interface: $wifi_interface"
echo "-------------------------------"

echo "SSID             | Password"
echo "----------------------------"

max_ssid_length=0
max_password_length=0

# Find the maximum length of SSID and password
for file in /etc/NetworkManager/system-connections/*; do
    ssid=$(sudo grep -oP "(?<=ssid=)[^']*" "$file")
    password=$(sudo grep -oP "(?<=psk=)[^']*" "$file")
    
    if [[ ${#ssid} -gt $max_ssid_length ]]; then
        max_ssid_length=${#ssid}
    fi
    
    if [[ ${#password} -gt $max_password_length ]]; then
        max_password_length=${#password}
    fi
done

# Display saved Wi-Fi SSIDs and passwords with adjusted columns
for file in /etc/NetworkManager/system-connections/*; do
    ssid=$(sudo grep -oP "(?<=ssid=)[^']*" "$file")
    password=$(sudo grep -oP "(?<=psk=)[^']*" "$file")
    
    ssid_padding=$((max_ssid_length - ${#ssid}))
    password_padding=$((max_password_length - ${#password}))
    
    if [[ "$ssid" == "$connected_ssid" ]]; then
        printf "${GREEN}%s%*s | %s%*s${NC}\n" "$ssid" "$ssid_padding" "" "$password" "$password_padding"
    else
        printf "%s%*s | %s%*s\n" "$ssid" "$ssid_padding" "" "$password" "$password_padding"
    fi
done

# Display currently connected Wi-Fi in green
connected_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
if [[ -n $connected_ssid ]]; then
    separator="----------------------------"
    connected_line="Currently Connected Wi-Fi: $connected_ssid"
    
    # Center-align the connected line
    connected_line_length=${#connected_line}
    padding_length=$(((${#separator} - $connected_line_length) / 2))
    
    echo "$separator"
    printf "%*s\n" $((connected_line_length + padding_length)) "$connected_line"
    
    # Display list of devices connected to the current Wi-Fi
    echo "$separator"
    echo "Devices Connected to $connected_ssid:"
    ip neigh show | grep "dev $wifi_interface" | awk '{print $1, $5}'
    
    # Display current private IP, gateway, MAC address, and IPv6
    echo "$separator"
    echo "Your Network Information:"
    private_ip=$(ip -o -4 addr show dev $wifi_interface | awk '{print $4}' | cut -d/ -f1)
    gateway=$(ip route | grep default | awk '{print $3}')
    mac_address=$(ip link show dev $wifi_interface | awk '/ether/ {print $2}')
    ipv6_address=$(ip -o -6 addr show dev $wifi_interface | awk '{print $4}' | cut -d/ -f1)
    
    echo "Private IP:     $private_ip"
    echo "Gateway:        $gateway"
    echo "MAC Address:    $mac_address"
    echo "IPv6 Address:   $ipv6_address"
fi
