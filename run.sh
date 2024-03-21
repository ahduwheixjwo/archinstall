#!/bin/bash

set -e
printf '\033c'

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

# Check chipset vendor and install essential packages
if cat /proc/cpu | grep -q 'Intel'; then
    pacstrap -K /mnt base linux-zen linux-firmware nano intel-ucode
else
    pacstrap -K /mnt base linux-zen linux-firmware nano amd-ucode
fi

# Generate FSTAB file
genfstab -U /mnt >> /mnt/etc/fstab

# Begin system configuraion
source $PWD/Scripts/configure.sh
arch-chroot /mnt /bin/bash -c "$(declare -f configure); configure"

printf '\033c'
echo "==> All installation and configuration have been done. Rebooting..."

sleep 1
reboot