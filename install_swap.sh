#!/bin/bash

sudo dd if=/dev/zero of=/swapfile count=2048 bs=1M  # create a 2GB swap file

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
# We have our swap file enabled, but when we reboot, the server will not automatically enable the file. We can change that though by modifying the fstab file.
# Edit the file with root privileges in your text editor:
sudo vim /etc/fstab
# At the bottom of the file, you need to add a line that will tell the operating system to automatically use the file you created:
/swapfile   none    swap    sw    0   0
# Save and close the file when you are finished.
