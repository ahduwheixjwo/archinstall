#!/bin/bash

set -e

source variable.sh

# list block of available disk
lsblk
echo ""

# Check for disk
while true; do
    echo "Enter your preferred disk (ex: /dev/sda)"
    read -p ">>" disk

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

# Variable for disk size
diskSize=$(lsblk $disk | grep disk | awk '{print $4}')

# Customize each partition size
partitioning $diskSize

# Partition using fdisk utility
printf g\nn\n\n\n+"$efiPartition"M\nn\n\n\n+"$swapPartition"G\nn\n\n\nt\n1\n1\nt\n2\n19\nw\n | fdisk "$disk" >/dev/null 2>&1