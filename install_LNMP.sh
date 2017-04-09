#!/bin/bash

#
sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
sudo apt-add-repository -y ppa:nginx/stable

#
sudo apt-get -y update && sudo apt-get -y upgrade

#
sudo apt-get install -y nginx

# 安装 php5.6
echo "----> start installing php5.6 ..."
sudo apt-get -y install php5.6 php5.6-cli php5.6-fpm php5.6-mysql php5.6-gd php5.6-curl php5.6-mbstring php5.6-dom php5-xdebug php5.6-zip php5.6-bz2 php5.6-json php5.6-opcache php5.6-readline


# 安装 composer
echo "----> start installing composer ..."
sudo curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/bin/composer
sudo rm -f composer.phar 

# 安装 mysql5.6 
# 网上有说用这个ppa:ondrej/mysql-5.6，不要用！！
# sudo add-apt-repository -y ppa:ondrej/mysql-5.6  # Don't use, it's broken.!!!
# http://askubuntu.com/questions/690855/mysql-5-6-dpkg-install-error-even-after-complete-uninstall
# 注意在vagrant中至少要分配1024内存，否则无法启动 failed to start
echo "----> start installing mysql5.6 ..."
sudo apt-get -y install debconf-utils
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password MYSQL_20170324_!@#'  # 设置mysql的root密码！！
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password MYSQL_20170324_!@#'
sudo apt-get -y install mysql-server-5.6 mysql-client-5.6
