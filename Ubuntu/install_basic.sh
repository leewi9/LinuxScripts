#!/bin/bash

echo "-----> $HOME"
echo "-----> $PWD"

# 配置源
# sudo sed -i 's#http://archive.ubuntu.com#http://cn.archive.ubuntu.com#g' /etc/apt/sources.list
# sudo apt-get -y update

# 设置时区
sudo timedatectl set-timezone Asia/Shanghai

# 设置 locale
# 解决远程服务器的语言编码与终端的编码不一致
# Centos系统还需要安装中文语言包  yum -y groupinstall chinese-support
# 如果SSH终端还是乱码，那么我们也需要对终端软件的编码进行设置。设置编码为UTF-8。
# 如果不正确设置这些，在安装postgresql时貌似会报错
sudo locale-gen en_US.UTF-8
# echo 'LC_ALL="en_US.UTF-8"' | sudo tee --append /etc/default/locale > /dev/null
# echo 'LANG="en_US.UTF-8"' | sudo tee --append /etc/default/locale > /dev/null
# echo 'LANGUAGE="en_US:en"' | sudo tee --append /etc/default/locale > /dev/null
# 上面3句可以用下面来实现
sudo update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US:en"

#
sudo apt-get -y update && sudo apt-get -y upgrade

#####  #####
# 开发环境
sudo apt-get install -y binutils build-essential ant gawk

# 工具
sudo apt-get install -y git vim zip htop wget tree
sudo apt-get install -y supervisor
sudo apt-get install -y debian-goodies  # dpigs -H

#####
sudo apt-get -y upgrade

#
sudo apt-get autoremove -y

# TODO System Restart Required
# sudo reboot

# TODO 验证要安装的是否确实都已经正确安装
