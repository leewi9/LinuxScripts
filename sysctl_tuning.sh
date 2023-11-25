#!/bin/bash

###############################################################
# 1、backup
mv /etc/sysctl.conf /etc/sysctl.conf.bak
mv /etc/security/limits.conf /etc/security/limits.conf.bak
###############################################################

###############################################################
# 2、run
###############################################################

which bc
if [ $? -ne 0 ]; then
    echo "This script require GNU bc, cf. http://www.gnu.org/software/bc/"
    echo "On Linux Debian/Ubuntu you can install it by doing : apt-get install bc"
fi

host=$(hostname)
ARCH=$(uname -m)
echo "Update sysctl for $host"

mem_bytes=$(awk '/MemTotal:/ { printf "%0.f",$2 * 1024}' /proc/meminfo)
shmmax=$(echo "$mem_bytes * 0.90" | bc | cut -f 1 -d '.')
shmall=$(expr $mem_bytes / $(getconf PAGE_SIZE))
file_max=$(echo "$mem_bytes / 4194304 * 256" | bc | cut -f 1 -d '.')
min_free=$(echo "($mem_bytes / 1024) * 0.10" | bc | cut -f 1 -d '.')

>/etc/security/limits.conf cat << EOF 

* soft nofile $file_max
* hard nofile $file_max
* soft nproc $file_max
* hard nproc $file_max

EOF

>/etc/sysctl.conf cat << EOF 

### IMPROVE SYSTEM MEMORY MANAGEMENT ###

# Increase size of file handles and inode cache
# fs.file-max = 209708
fs.file-max = $file_max

# Do less swapping
# * 0: swap is disable
# * 1: minimum amount of swapping without disabling it entirely
# * 10: recommended value to improve performance when sufficient memory exists in a system
# * 100: aggressive swapping
vm.swappiness = 10

# Set maximum amount of memory allocated to shm to 256MB
# kernel.shmmax = 268435456
# kernel.shmall = 268435456
# Maximum shared segment size in bytes
kernel.shmmax = $shmmax
# Maximum number of shared memory segments in pages
kernel.shmall = $shmall

# Keep at least 64MB of free RAM space available
# vm.min_free_kbytes = 65535
vm.min_free_kbytes = $min_free

### IMPROVE UDP ###
net.core.rmem_default = 16777216  # 16MB
net.core.rmem_max = 16777216  # 16MB
net.core.wmem_default = 16777216  # 16MB
net.core.wmem_max = 16777216  # 16MB

EOF

###############################################################
# 3、take effect
/sbin/sysctl -p /etc/sysctl.conf
# reboot
###############################################################

