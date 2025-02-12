#!/bin/bash

# This script sets up a development environment on Debian 12
# It installs essential development tools, utilities, NTPsec, and configures DNS.

# Exit on any error
set -e

###########################################
# Functions
###########################################

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script must be run as root"
        echo "Please run with sudo: 'sudo ./dev.sh'"
        exit 1
    fi
}

update_and_upgrade() {
    echo "Updating package lists and upgrading installed packages..."
    sudo apt-get update
    sudo apt-get upgrade -y
}

install_dev_tools() {
    echo "Installing development tools..."
    sudo apt-get install -y binutils build-essential ant gawk
}

install_utilities() {
    echo "Installing utilities..."
    sudo apt-get install -y git vim zip htop wget tree lrzsz cron
    sudo apt-get install -y supervisor
    sudo apt-get install -y debian-goodies  # dpigs -H
    sudo apt-get install -y sysstat
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [-h|--help]

Set up a development environment on Debian 12.

Options:
    -h, --help    Show this help message

This script will:
1. Update package lists and upgrade installed packages
2. Install essential development tools
3. Install useful utilities

Note: This script must be run as root.
EOF
    exit 0
}

###########################################
# Main Script
###########################################

main() {
    # Show help if requested
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_help
    fi

    # Check root privileges
    check_root

    echo "Starting development environment setup..."

    update_and_upgrade
    install_dev_tools
    install_utilities

    echo "Development environment setup completed successfully!"
}

# Run main function with all arguments
main "$@" 