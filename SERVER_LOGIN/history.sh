#!/bin/bash

while true; do
    clear
    echo "Login History Menu"
    echo "=================="
    echo "1. SSH Login History"
    echo "2. FTP Login History"
    echo "3. Direct Login History"
    echo "4. MySQL Login History"
    echo "5. Exit"
    read -p "Select an option: " choice

    case $choice in
        1)
            echo "SSH Login History:"
            echo "=================="
            last -i
            ;;
        2)
            echo "FTP Login History:"
            echo "=================="
            grep "FTP session opened" /var/log/vsftpd.log
            ;;
        3)
            echo "Direct Login History:"
            echo "====================="
            last -w
            ;;
        4)
            echo "MySQL Login History:"
            echo "===================="
            grep "Access denied" /var/log/mysql/mysql.log
            ;;
        5)
            echo "Exiting..."
            exit
            ;;
        *)
            echo "Invalid choice. Please select a valid option."
            ;;
    esac

    read -p "Press Enter to continue..."
done
