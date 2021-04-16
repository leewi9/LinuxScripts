#!/bin/bash
#
# Author : Nicolas Brousse
#
# Notes :
#   This script is a simple "helper" to configure your sysctl.conf on linux
#   There is no silver bullet. Don't expect the perfect setup, review comments
#   and adapt the parameters to your needs and application usage.
#
#   Use this script at your OWN risk. There is no guarantee whatsoever.


# 验证当前TCP控制算法的命令
# sysctl net.ipv4.tcp_available_congestion_control
# 返回值一般为：
# net.ipv4.tcp_available_congestion_control = bbr cubic reno
# 或者为：
# net.ipv4.tcp_available_congestion_control = reno cubic bbr

# 验证BBR是否已经启动
# sysctl net.ipv4.tcp_congestion_control 
# 返回值一般为：
# net.ipv4.tcp_congestion_control = bbr

# lsmod | grep bbr 
# 返回值有 tcp_bbr 模块即说明 bbr 已启动
# 注意：并不是所有的 VPS 都会有此返回值，若没有也属正常


###############################################################
# 1、backup
mv /etc/sysctl.conf /etc/sysctl.conf.bak
# 2、run
###############################################################

#
>/etc/sysctl.conf cat << EOF 

###
### GENERAL SYSTEM SECURITY OPTIONS ###
###

# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
kernel.core_uses_pid = 1

#Allow for more PIDs
kernel.pid_max = 65535

# The contents of /proc/<pid>/maps and smaps files are only visible to
# readers that are allowed to ptrace() the process
kernel.maps_protect = 1

#Enable ExecShield protection
kernel.exec-shield = 1
kernel.randomize_va_space = 2

# Controls the maximum size of a message, in bytes
kernel.msgmnb = 65535

# Controls the default maxmimum size of a mesage queue
kernel.msgmax = 65535

# Restrict core dumps
fs.suid_dumpable = 0

# Hide exposed kernel pointers
kernel.kptr_restrict = 1



###
### IMPROVE SYSTEM MEMORY MANAGEMENT ###
###

# Increase size of file handles and inode cache
# fs.file-max = 209708
fs.file-max = $file_max

# Do less swapping
vm.swappiness = 30
# for non ssd
# vm.dirty_background_ratio = 5
# vm.dirty_ratio = 30
# for ssd
# This setup is generally ok for ssd and highmem servers
vm.dirty_background_ratio = 3
vm.dirty_ratio = 5

# specifies the minimum virtual address that a process is allowed to mmap
vm.mmap_min_addr = 4096

# 50% overcommitment of available memory
vm.overcommit_ratio = 50
vm.overcommit_memory = 0

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


###
### GENERAL NETWORK SECURITY OPTIONS ###
###

#Prevent SYN attack, enable SYNcookies (they will kick-in when the max_syn_backlog reached)
# but syncookies are not RFC compliant and can use too muche resources
net.ipv4.tcp_syncookies = 1  # or 0?
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_max_syn_backlog = 4096
# TODO : change TCP_SYNQ_HSIZE in include/net/tcp.h to keep TCP_SYNQ_HSIZE*16<=tcp_max_syn_backlog

# Disables packet forwarding
net.ipv4.ip_forward = 0
net.ipv4.conf.all.forwarding = 0
net.ipv4.conf.default.forwarding = 0
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.default.forwarding = 0

# Disables IP source routing
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Enable IP spoofing protection, turn on source route verification
# (RFC1812)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Disable ICMP Redirect Acceptance
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Enable Log Spoofed Packets, Source Routed Packets, Redirect Packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Decrease the time default value for tcp_fin_timeout connection
# how long to keep sockets in the state FIN-WAIT-2 if we were the one closing the socket
net.ipv4.tcp_fin_timeout = 7

# Decrease the time default value for connections to keep alive
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15

# Don't relay bootp
net.ipv4.conf.all.bootp_relay = 0

# Don't proxy arp for anyone
net.ipv4.conf.all.proxy_arp = 0

# Turn on the tcp_timestamps, accurate timestamp make TCP congestion control algorithms work better
# Enable timestamps (RFC1323)
net.ipv4.tcp_timestamps = 1

# Enable select acknowledgments
net.ipv4.tcp_sack = 1

# Don't ignore directed pings
net.ipv4.icmp_echo_ignore_all = 0

# Enable FACK congestion avoidance and fast restransmission
net.ipv4.tcp_fack = 1

# Allows TCP to send "duplicate" SACKs
net.ipv4.tcp_dsack = 1

# Enable ignoring broadcasts request
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Enable bad error message Protection
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Defines the local port range that is used by TCP and UDP to choose the local port
net.ipv4.ip_local_port_range = 16384 65535

# Enable a fix for RFC1337 - time-wait assassination hazards in TCP
net.ipv4.tcp_rfc1337 = 1

# Do not auto-configure IPv6
net.ipv6.conf.all.autoconf=0
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.default.autoconf=0
net.ipv6.conf.default.accept_ra=0
net.ipv6.conf.eth0.autoconf=0
net.ipv6.conf.eth0.accept_ra=0



###
### TUNING NETWORK PERFORMANCE ###
###

# Use BBR TCP congestion control and set tcp_notsent_lowat to 16384 to ensure HTTP/2 prioritization works optimally
# Do a 'modprobe tcp_bbr' first (kernel > 4.9)
# Fall-back to htcp if bbr is unavailable (older kernels)
net.ipv4.tcp_notsent_lowat = 16384
# net.ipv4.tcp_congestion_control = htcp
# net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_congestion_control=bbrplus

# For servers with tcp-heavy workloads, enable 'fq' queue management scheduler (kernel > 3.12)
net.core.default_qdisc = fq
# The default network queuing discipline should avoid buffer bloat – which destroys latency. net.core.default_qdisc sets the default queuing mechanism for Linux networking. It has very significant effects on network performance and latency. sch_fq_codel is the current best queuing discipline for performance and latency on Linux machines.

# Turn on the tcp_window_scaling
net.ipv4.tcp_window_scaling = 1

# Increase the read-buffer space allocatable
net.ipv4.tcp_rmem = 8192 87380 16777216
net.ipv4.udp_rmem_min = 16384
net.core.rmem_default = 262144
net.core.rmem_max = 16777216

# Increase the write-buffer-space allocatable
net.ipv4.tcp_wmem = 8192 65536 16777216
net.ipv4.udp_wmem_min = 16384
net.core.wmem_default = 262144
net.core.wmem_max = 16777216

# Increase number of incoming connections
net.core.somaxconn = 65536

# Increase number of incoming connections backlog
net.core.netdev_max_backlog = 16384
net.core.dev_weight = 64

# Increase the maximum amount of option memory buffers
net.core.optmem_max = 65535

# Increase the tcp-time-wait buckets pool size to prevent simple DOS attacks
net.ipv4.tcp_max_tw_buckets = $max_tw

# try to reuse time-wait connections, but don't recycle them (recycle can break clients behind NAT)
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 1
# Enable fast recycling TIME-WAIT sockets
# https://stackoverflow.com/questions/6426253/tcp-tw-reuse-vs-tcp-tw-recycle-which-to-use-or-both

# Limit number of orphans, each orphan can eat up to 16M (max wmem) of unswappable memory
max_orphan=$(echo "$mem_bytes * 0.10 / 65536" | bc | cut -f 1 -d '.')
net.ipv4.tcp_max_orphans = $max_orphan
# How may times to retry before killing TCP connection, closed by our side
net.ipv4.tcp_orphan_retries = 1

# Limit the maximum memory used to reassemble IP fragments (CVE-2018-5391)
net.ipv4.ipfrag_low_thresh = 196608
net.ipv6.ip6frag_low_thresh = 196608
net.ipv4.ipfrag_high_thresh = 262144
net.ipv6.ip6frag_high_thresh = 262144

# don't cache ssthresh from previous connection
net.ipv4.tcp_no_metrics_save = 1
net.ipv4.tcp_moderate_rcvbuf = 1

# Increase size of RPC datagram queue length
net.unix.max_dgram_qlen = 50

# Don't allow the arp table to become bigger than this
net.ipv4.neigh.default.gc_thresh3 = 2048

# Tell the gc when to become aggressive with arp table cleaning.
# Adjust this based on size of the LAN. 1024 is suitable for most /24 networks
net.ipv4.neigh.default.gc_thresh2 = 1024

# Adjust where the gc will leave arp table alone - set to 32.
net.ipv4.neigh.default.gc_thresh1 = 32

# Adjust to arp table gc to clean-up more often
net.ipv4.neigh.default.gc_interval = 30

# Increase TCP queue length
net.ipv4.neigh.default.proxy_qlen = 96
net.ipv4.neigh.default.unres_qlen = 6

# Enable Explicit Congestion Notification (RFC 3168), disable it if it doesn't work for you
net.ipv4.tcp_ecn = 1
net.ipv4.tcp_reordering = 3

# How many times to retry killing an alive TCP connection
net.ipv4.tcp_retries2 = 15
net.ipv4.tcp_retries1 = 3

# Avoid falling back to slow start after a connection goes idle
# keeps our cwnd large with the keep alive connections (kernel > 3.6)
net.ipv4.tcp_slow_start_after_idle = 0

# Allow the TCP fastopen flag to be used, beware some firewalls do not like TFO! (kernel > 3.7)
net.ipv4.tcp_fastopen = 3

# This will enusre that immediatly subsequent connections use the new values
net.ipv4.route.flush = 1
net.ipv6.route.flush = 1

EOF

# 3、take effect
/sbin/sysctl -p /etc/sysctl.conf