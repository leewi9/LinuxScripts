#!/bin/bash

# This script installs and configures NTPsec, a security-hardened implementation
# of the Network Time Protocol (NTP).
#
# NTPsec is a fork of the original NTP Classic that focuses on:
# - Security improvements (removed ~74% of original codebase to reduce attack surface)
# - Implementation of Network Time Security (NTS) standard
# - Removal of deprecated and vulnerable features (like Autokey, broadcast mode)
# - Better maintainability and code verification
# - Modern features while maintaining compatibility with NTP Classic
#
# Reference: https://docs.ntpsec.org/latest/ntpsec.html

# Exit on any error
set -e

###########################################
# Functions
###########################################

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script must be run as root"
        exit 1
    fi
}

install_ntp() {
    echo "Installing NTP service..."
    apt-get update
    apt-get install -y ntpsec
}

configure_ntp() {
    local ntp_conf="/etc/ntpsec/ntp.conf"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    echo "Configuring NTP..."
    
    # Check if config exists
    if [ ! -f "$ntp_conf" ]; then
        echo "Error: NTP configuration file $ntp_conf not found!"
        echo "Please ensure ntpsec is properly installed."
        echo "Try reinstalling the package: apt-get install --reinstall ntpsec"
        exit 1
    fi
    
    # Backup original config
    cp "$ntp_conf" "${ntp_conf}.bak_${timestamp}"
    
    # Create temporary file for new config
    local temp_conf="${ntp_conf}.tmp"
    
    # Copy original content excluding existing pool/server lines
    grep -v "^pool\|^server" "$ntp_conf" > "$temp_conf"
    
    # Add custom servers at the beginning if provided
    if [ $# -gt 0 ]; then
        echo "Using custom NTP servers: $@"
        printf "\n# Custom NTP servers\n" >> "$temp_conf"
        for server in "$@"; do
            printf "pool %s iburst\n" "$server" >> "$temp_conf"
        done
    fi
    
    # Add default servers
    printf "\n# Default NTP servers\n" >> "$temp_conf"
    {
        printf "pool time.nist.gov iburst\n"
        printf "pool 0.debian.pool.ntp.org iburst\n"
        printf "pool 1.debian.pool.ntp.org iburst\n"
        printf "pool 2.debian.pool.ntp.org iburst\n"
        printf "pool 3.debian.pool.ntp.org iburst\n"
    } >> "$temp_conf"
    
    # Replace original with new config
    mv "$temp_conf" "$ntp_conf"
    echo "NTP configuration updated while preserving original settings"
}

restart_ntp() {
    echo "Restarting NTP service..."
    systemctl restart ntpsec
    systemctl enable ntpsec
}

verify_ntp() {
    echo "Verifying NTP status..."
    sleep 2  # Give NTP a moment to initialize
    
    if ! systemctl is-active --quiet ntpsec; then
        echo "Error: NTP service is not running"
        exit 1
    fi

    echo "NTP service status:"
    ntpq -p
    
    printf "\nNTP synchronization status:\n"
    ntpq -c rv
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [ntp_server1] [ntp_server2] ...

Configure NTP (Network Time Protocol) service with specified servers.

Options:
    -h, --help     Show this help message

Arguments:
    ntp_server     Optional: One or more NTP server hostnames
                   If no servers specified, uses default servers:
                   - time.nist.gov
                   - 0-3.debian.pool.ntp.org

Examples:
    $(basename "$0")                          # Use default NTP servers
    $(basename "$0") pool.ntp.org             # Use custom NTP server
    $(basename "$0") ntp1.example.com ntp2.example.com  # Use multiple custom servers

    Some china mainland ntp servers:
    - ntp.aliyun.com
    - ntp.tencent.com
    - ntp.sjtu.edu.cn
    - ntp.ustc.edu.cn
    - ntp.sjtu.edu.cn
    

Note: Custom servers will be prioritized, with default servers added as fallback.
EOF
    exit 0
}

###########################################
# Main Script
###########################################

main() {
    echo "Starting NTP setup..."
    
    # Show help if requested
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_help
    fi
    
    check_root
    install_ntp
    configure_ntp "$@"
    restart_ntp
    verify_ntp
    
    echo "NTP setup completed successfully!"
}

# Run main function with all arguments
main "$@"
