#!/bin/bash

# Default swap size in MB if no parameter is provided
SWAP_SIZE=${1:-1024}

# Validate that the input is a number
if ! [[ "$SWAP_SIZE" =~ ^[0-9]+$ ]]; then
    echo "Error: Swap size must be a number"
    echo "Usage: $0 [size_in_MB]"
    echo "Example: $0 1024 (for 1GB)"
    exit 1
fi

echo "Resizing swap file to: ${SWAP_SIZE}MB"

# Turn off swap
sudo swapoff /swapfile

# Create new swap file
sudo dd if=/dev/zero of=/swapfile count=$SWAP_SIZE bs=1M

# Set correct permissions
sudo chmod 600 /swapfile

# Make the file usable for swap
sudo mkswap /swapfile

# Turn swap back on
sudo swapon /swapfile

echo "Swap file has been resized to ${SWAP_SIZE}MB"
