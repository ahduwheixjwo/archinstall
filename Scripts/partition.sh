#!/bin/bash

set -e

source $PWD/Scripts/variable.sh

# list block of available disk
lsblk
echo ""

# Check for disk
while true; do
    echo "Enter your preferred disk (ex: /dev/sda)"
    read -p ">>" disk
    echo ""

    # Check if user's disk is existed
    if lsblk "$disk" >/dev/null 2>&1; then 
        break
    else
        echo "Disk $disk doesn't exist..."
        echo ""
    fi
done

# Format the disk
printf "x\nz\ny\ny\n" | gdisk "$disk" >/dev/null 2>&1

# Customize each partition size
partitioning

# Partition using fdisk utility
printf "g\nn\n\n\n+$efiPartition\nn\n\n\n+$swapPartition\nn\n\n\n\nt\n1\n1\nt\n2\n19\nw\n" | fdisk "$disk" >/dev/null 2>&1

# Format all partition
mkfs.vfat "${$disk}1"
mkswap "${$disk}2"
mkfs.ext4 "${$disk}3"

# Mount partition
mount "${$disk}3" /mnt
mount --mkdir "${$disk}1" /mnt/boot
swapon "${$disk}2"