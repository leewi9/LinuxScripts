#!/bin/bash

sudo dd if=/dev/zero of=/swapfile count=256 bs=1M  # create swap file

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
