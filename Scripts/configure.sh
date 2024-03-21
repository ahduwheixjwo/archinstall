#!/bin/bash

set -e

configure() {
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

    # Set system hostname
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
    echo "$hostname" > /etc/hostname

    # Configuring hostname resolution
    cat << EOF | tee -a /etc/hosts >/dev/null 2>&1
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain $hostname
EOF
    # Set password
    passwd

    # Enable multilib for pacman and install required packages
    sed -i '/\[multilib\]/,/Include/ s/^#//' /etc/pacman.conf
    pacman -Sy grub efibootmgr base-devel git linux-zen-headers networkmanager

    # Set username
    while true; do
        echo "Enter your preferred username"
        read -p ">>" username
        echo ""

        if [[ -z "$username" ]];then
            echo "Please enter your preferred username..."
            echo ""
        else
            break
        fi
    done
    useradd -m -G wheel "$username"

    # Set password for username
    passwd "$username"
}