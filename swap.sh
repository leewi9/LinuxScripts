#!/bin/bash

# Default swap size in MB if no parameter is provided
SWAP_SIZE=${1:-512}

# Validate that the input is a number
if ! [[ "$SWAP_SIZE" =~ ^[0-9]+$ ]]; then
    echo "Error: Swap size must be a number"
    echo "Usage: $0 [size_in_MB]"
    echo "Example: $0 1024 (for 1GB)"
    exit 1
fi

echo "Creating swap file with size: ${SWAP_SIZE}MB"
sudo dd if=/dev/zero of=/swapfile count=$SWAP_SIZE bs=1M  # create swap file

# verify that the file is located at the root of your Vultr VPS by running:
ls / | grep swapfile

# Activate the swap file
sudo chmod 600 /swapfile

#
sudo ls -lh /swapfile  

# tell the server to setup the swap file
sudo mkswap /swapfile

# Turn swap on
sudo swapon /swapfile

# Make the Swap File Permanent
sudo su -c "echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab"
