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

###############################################################
# 1、backup
mv /etc/sysctl.conf /etc/sysctl.conf.bak
# 2、run
copy v1.conf /etc/sysctl.conf
# 3、take effect
/sbin/sysctl -p /etc/sysctl.conf
###############################################################
