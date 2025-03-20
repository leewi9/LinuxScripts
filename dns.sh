#!/bin/bash

# This script configures custom DNS servers on Debian 12
# It supports NetworkManager, systemd-resolved, and direct resolv.conf modification

# Exit on any error
set -e

###########################################
# Functions
###########################################

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Error: This script must be run as root"
        echo "Please run with sudo: 'sudo ./dns.sh'"
        exit 1
    fi
}

backup_config() {
    local file="$1"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    if [ -f "$file" ]; then
        echo "Backing up $file..."
        cp "$file" "${file}.bak_${timestamp}"
    fi
}

detect_dns_system() {
    # Check for NetworkManager
    if command -v nmcli >/dev/null 2>&1; then
        echo "networkmanager"
        return
    fi

    # Check for systemd-resolved
    if [ -f "/etc/systemd/resolved.conf" ] && systemctl is-active --quiet systemd-resolved; then
        echo "resolved"
        return
    fi

    # Fallback to direct resolv.conf
    echo "resolv"
}

configure_networkmanager() {
    local dns_servers="$1"
    local connection
    
    echo "Configuring NetworkManager DNS settings..."
    
    # Get the active connection
    connection=$(nmcli -t -f UUID,TYPE,DEVICE connection show --active | grep ethernet | cut -d: -f1)
    
    if [ -z "$connection" ]; then
        echo "Error: No active ethernet connection found"
        exit 1
    fi
    
    # Check current DNS settings
    current_dns=$(nmcli connection show "$connection" | grep "ipv4.dns:" | awk '{$1=""; print $0}' | xargs)
    if [ "$current_dns" = "$dns_servers" ]; then
        echo "DNS servers already configured correctly"
        return
    fi
    
    # Modify the connection
    echo "Updating DNS servers..."
    nmcli connection modify "$connection" ipv4.dns "$dns_servers"
    nmcli connection modify "$connection" ipv4.ignore-auto-dns yes
    
    # Restart the connection
    echo "Restarting network connection..."
    nmcli connection down "$connection"
    nmcli connection up "$connection"
}

configure_resolved() {
    local dns_servers="$*"
    local resolved_conf="/etc/systemd/resolved.conf"
    
    echo "Configuring systemd-resolved DNS settings..."
    
    # Check if current config matches desired config
    if [ -f "$resolved_conf" ]; then
        current_dns=$(grep "^DNS=" "$resolved_conf" | cut -d= -f2)
        if [ "$current_dns" = "$dns_servers" ]; then
            echo "DNS servers already configured correctly"
            return
        fi
    fi
    
    # Backup and update config
    backup_config "$resolved_conf"
    
    # Update resolved.conf
    cat > "$resolved_conf" << EOF
# Generated by dns.sh on $(date)
[Resolve]
DNS=$dns_servers
#FallbackDNS=1.1.1.1 8.8.8.8
#Domains=
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=yes
#LLMNR=yes
#Cache=yes
#DNSStubListener=yes
EOF

    # Restart systemd-resolved only if config changed
    echo "Restarting systemd-resolved..."
    systemctl restart systemd-resolved
}

configure_resolv_conf() {
    local dns_servers="$*"
    local resolv_conf="/etc/resolv.conf"
    local temp_content
    local current_servers
    
    echo "Configuring resolv.conf DNS settings..."
    
    # Check if resolv.conf is immutable, remove attribute if it is
    if lsattr "$resolv_conf" 2>/dev/null | grep -q '^....i'; then
        echo "Removing immutable attribute to modify file..."
        chattr -i "$resolv_conf"
    fi
    
    # Generate desired content
    temp_content="# Generated by dns.sh on $(date)\n# DNS Servers\n"
    for server in $dns_servers; do
        temp_content="${temp_content}nameserver $server\n"
    done
    temp_content="${temp_content}options timeout:2 attempts:3 rotate"
    
    # Check current content (excluding comments and timestamps)
    if [ -f "$resolv_conf" ]; then
        current_servers=$(grep "^nameserver" "$resolv_conf" | awk '{print $2}' | sort | tr '\n' ' ' | sed 's/ $//')
        new_servers=$(echo "$dns_servers" | tr ' ' '\n' | sort | tr '\n' ' ' | sed 's/ $//')
        
        if [ "$current_servers" = "$new_servers" ]; then
            echo "DNS servers already configured correctly"
            # Ensure file is immutable
            if ! lsattr "$resolv_conf" 2>/dev/null | grep -q '^....i'; then
                echo "Making resolv.conf immutable..."
                chattr +i "$resolv_conf"
            fi
            return
        fi
    fi
    
    # Backup existing config
    backup_config "$resolv_conf"
    
    # Check if resolv.conf is a symlink
    if [ -L "$resolv_conf" ]; then
        echo "Warning: $resolv_conf is a symlink. Creating new file..."
        rm "$resolv_conf"
    fi
    
    # Write new content
    printf "%b" "$temp_content" > "$resolv_conf"
    
    # Make it immutable to prevent modification by DHCP
    echo "Making resolv.conf immutable..."
    chattr +i "$resolv_conf"
}

verify_dns() {
    echo "Verifying DNS configuration..."
    
    # Wait longer for DNS to be ready (increased from 2 to 5 seconds)
    echo "Waiting for DNS changes to take effect..."
    sleep 5
    
    # Show current DNS servers based on system
    echo "Current DNS servers:"
    case $(detect_dns_system) in
        "networkmanager")
            nmcli device show | grep DNS
            ;;
        "resolved")
            resolvectl status
            ;;
        *)
            cat /etc/resolv.conf | grep nameserver
            ;;
    esac
    
    # Test DNS resolution with multiple attempts and different domains
    printf "\nTesting DNS resolution...\n"
    
    # Function to test DNS resolution
    test_dns() {
        local domain="$1"
        local timeout="$2"
        echo "Testing resolution of $domain..."
        if dig +time="$timeout" +tries=1 "$domain" @8.8.8.8 +short >/dev/null 2>&1; then
            return 0
        else
            return 1
        fi
    }

    # Try multiple domains with increasing timeouts
    if test_dns "google.com" 2 || test_dns "cloudflare.com" 3 || test_dns "debian.org" 4; then
        echo "DNS resolution test successful"
    else
        echo "Warning: DNS resolution test failed"
        echo "Diagnostic information:"
        echo "1. Checking network connectivity..."
        if ping -c 1 -W 5 8.8.8.8 >/dev/null 2>&1; then
            echo "   Network is reachable"
        else
            echo "   Network appears to be unreachable"
            echo "   Please check your network connection"
        fi
        
        echo "2. DNS server response:"
        for server in $(grep "^nameserver" /etc/resolv.conf | awk '{print $2}'); do
            echo "   Testing DNS server $server..."
            if dig +time=2 +tries=1 @"$server" google.com >/dev/null 2>&1; then
                echo "   - Server $server is responding to DNS queries"
            else
                echo "   - Server $server is not responding to DNS queries"
            fi
        done
        
        echo "3. DNS query details (verbose):"
        dig +trace google.com
        
        echo "Please check your DNS configuration and network connectivity"
        exit 1
    fi
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [-h|--help] [dns_server1] [dns_server2] ...

Configure custom DNS servers on Debian 12.

Options:
    -h, --help    Show this help message

Arguments:
    dns_server    One or more DNS server IP addresses
                  If none provided, uses default:
                  - 1.1.1.1 (Cloudflare)
                  - 8.8.8.8 (Google)

Examples:
    $(basename "$0")                    # Use default DNS servers
    $(basename "$0") 1.1.1.1           # Use single DNS server
    $(basename "$0") 8.8.8.8 8.8.4.4   # Use multiple DNS servers

Note: 
- This script must be run as root
- Will automatically detect and use the appropriate DNS configuration method:
  1. NetworkManager (if available)
  2. systemd-resolved (if available)
  3. Direct /etc/resolv.conf modification (fallback)
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
    
    # Set DNS servers (default or from arguments)
    local dns_servers="${*:-1.1.1.1 8.8.8.8}"
    
    echo "Starting DNS configuration..."
    echo "Using DNS servers: $dns_servers"
    
    # Detect and configure based on available system
    case $(detect_dns_system) in
        "networkmanager")
            echo "Using NetworkManager for DNS configuration..."
            configure_networkmanager "$dns_servers"
            ;;
        "resolved")
            echo "Using systemd-resolved for DNS configuration..."
            configure_resolved $dns_servers
            ;;
        *)
            echo "Using direct resolv.conf modification..."
            configure_resolv_conf $dns_servers
            ;;
    esac
    
    verify_dns
    
    echo "DNS configuration completed successfully!"
}

# Run main function with all arguments
main "$@" 