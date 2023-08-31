#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Function to start the Tor service
start_tor() {
    service tor start
    echo "Tor proxy is now active. All non-Tor traffic is blocked."
    setup_iptables_redirect
}

# Function to stop the Tor service
stop_tor() {
    service tor stop
    echo "Tor proxy is now stopped. All traffic is allowed."
    clear_iptables_redirect
}

# Function to restart the Tor service
restart_tor() {
    service tor restart
    echo "Tor proxy is restarted."
    setup_iptables_redirect
}

# Function to install Tor if not already installed
install_tor() {
    if ! command -v tor &> /dev/null; then
        apt-get update
        apt-get install tor -y
        echo "Tor is now installed."
    else
        echo "Tor is already installed."
    fi
}

# Function to set up iptables rules to redirect traffic through Tor
setup_iptables_redirect() {
    iptables -F
    iptables -t nat -F
    iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 9040
    iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-ports 9040
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -j DROP
}

# Function to clear iptables rules
clear_iptables_redirect() {
    iptables -F
    iptables -t nat -F
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -j ACCEPT
}

echo "Tor Management Script"
echo "---------------------"
echo "1. Start Tor and redirect all traffic"
echo "2. Stop Tor and allow all traffic"
echo "3. Restart Tor and redirect all traffic"
echo "4. Route all internet traffic through Tor"
echo "5. Stop routing all internet traffic through Tor"
echo "6. Install Tor"
echo "7. Exit"

read -p "Enter the number of your choice: " choice

case "$choice" in
    1)
        install_tor
        start_tor
        ;;
    2)
        stop_tor
        ;;
    3)
        restart_tor
        ;;
    4)
        install_tor
        setup_iptables_redirect
        echo "All internet traffic is now routed through Tor."
        ;;
    5)
        stop_tor
        clear_iptables_redirect
        echo "Routing of all internet traffic through Tor is stopped."
        ;;
    6)
        install_tor
        ;;
    7)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
