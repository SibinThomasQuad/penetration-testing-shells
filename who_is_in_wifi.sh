#!/bin/bash

# Identify the IP address of your router
ROUTER_IP=`ip route | grep default | awk '{print $3}'`

# Identify the devices connected to your network
nmap -sn $ROUTER_IP/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'

