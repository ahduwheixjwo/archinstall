#!/bin/bash

set -e

# Function
connectInternet() {
    # List all available networks
    iwctl station wlan0 get-networks
    echo ""

    echo "Enter WiFi's BSSID"
    read -p ">>" bssid

    iwctl station wlan0 connect $bssid
}

# Check for internet connection
while true; do
    if ping -c 3 google.com > /dev/null 2>&1; then
        break
    else
        connectInternet
    fi
done

# Check if the system is using EFI
if [[ ! -d /sys/firmware/efi ]]; then
    echo "BIOS system detected. This script is only for EFI system. Aborting..."
    
    sleep 0.5
    exit 1
fi

# Partitioning
source $PWD/Scripts/partition.sh