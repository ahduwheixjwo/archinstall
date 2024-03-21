#!/bin/bash

set -e
printf '\033c'

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

    # Uncommenting wheel group
    echo "%wheel ALL=(ALL:ALL) ALL" | sudo tee /etc/sudoers.d/wheel

    # Install GRUB and update bootloader
    echo "==> Installing GRUB and updating bootloader..."
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB >/dev/null 2>&1
    grub-mkconfig -o /boot/grub/grub.cfg

    # Enable essential services
    sudo systemctl enable NetworkManager >/dev/null 2>&1
    sudo systemctl enable fstrim.timer >/dev/null 2>&1


}