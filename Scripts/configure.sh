#!/bin/bash

set -e

# Set time zone
ln -sf /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime
hwclock --systohc

# Set localization
local="en_US.UTF-8"

# Check if the locale existed and uncommented
if grep -q "^#$local" /etc/locale.gen; then
    # Uncomment the locale
    sed -i "s/^#$local/$local/" /etc/locale.gen
fi

# Update locale
locale-gen
echo LANG=$local > /etc/locale.conf

# Hostname
while true; do
    echo "Enter your preferred hostname"
    read -p ">>" hostname
    echo ""

    if [[ -z "$hostname" ]];then
        echo "Please enter your preferred hostname..."
        echo ""
    else
        break
    fi
done