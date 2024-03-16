#!/bin/bash

set -e

efiPartition=512
swapParttion=4

partitioning() {
    local totalDisk="$1"

    echo "Enter your preferred EFI partition size (default: 512M)."
    read -p ">>" efi
    echo ""

    echo "Enter your preferred swap partition size (default: 4GB)."
    read -p ">>" swap
    echo ""

    if [[ -n $efi ]];then
        efiPartition=$efi
    fi

    if [[ -n $swap ]];then
        swapPartition=$swap
    fi
}