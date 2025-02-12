#!/bin/bash

# 配置源
sudo sed -i 's#http://archive.ubuntu.com#http://cn.archive.ubuntu.com#g' /etc/apt/sources.list
sudo apt-get -y update

# 修改hostname
sudo vim /etc/hostname
sudo vim /etc/hosts      # 例如 127.0.1.1       linode2845632-Ubuntu.members.linode.com   linode2845632-Ubuntu

# 添加用户
adduser leewi9              # 需要设置密码、个人信息等
usermod -a -G sudo leewi9   # 加入sudo
su leewi9
cd ~