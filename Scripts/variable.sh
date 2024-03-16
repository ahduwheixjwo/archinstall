#!/bin/bash

set -e

efiPartition="512M"
swapPartition="4G"

partitioning() {

    echo "Enter your preferred EFI partition size (default: 512M)."
    read -p ">>" efi
    echo ""

    echo "Enter your preferred swap partition size (default: 4G)."
    read -p ">>" swap
    echo ""

    if [[ -n $efi ]]; then
        efiPartition=$efi
    fi

    if [[ -n $swap ]]; then
        swapPartition=$swap
    fi
}