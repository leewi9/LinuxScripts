#!/bin/bash

echo "-----> $HOME"
echo "-----> $PWD"

# 配置源
# sudo sed -i 's#http://archive.ubuntu.com#http://cn.archive.ubuntu.com#g' /etc/apt/sources.list
# sudo apt-get -y update

# 设置 locale
sudo locale-gen en_US.UTF-8
# echo 'LC_ALL="en_US.UTF-8"' | sudo tee --append /etc/default/locale > /dev/null
# echo 'LANG="en_US.UTF-8"' | sudo tee --append /etc/default/locale > /dev/null
# echo 'LANGUAGE="en_US:en"' | sudo tee --append /etc/default/locale > /dev/null
# 上面3句可以用下面来实现
sudo update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US:en"

# 设置时区
sudo timedatectl set-timezone Asia/Shanghai

# 同步时间
sudo apt-get -y update && sudo apt-get -y upgrade
apt install ntp -y
apt install ntpdate -y
ntpdate -u time.pool.aliyun.com

# 开发环境
sudo apt-get install -y binutils build-essential ant gawk

# 工具
sudo apt-get install -y git vim zip htop wget tree
sudo apt-get install -y supervisor
sudo apt-get install -y debian-goodies  # dpigs -H
sudo apt-get install -y sysstat
sudo apt-get -y upgrade
sudo apt-get autoremove -y

# TODO System Restart Required
# sudo reboot

# TODO 验证要安装的是否确实都已经正确安装
