#!/bin/bash

echo "-----> $HOME"
echo "-----> $PWD"

# 安装 php5.6
echo "----> start installing php5.6 ..."
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt-get -y update && upgrade
sudo apt-get -y install php5.6 php5.6-cli php5.6-fpm php5.6-mysql php5.6-gd php5.6-curl php5.6-mbstring php5.6-dom php5-xdebug php5.6-zip php5.6-bz2 php5.6-json php5.6-opcache php5.6-readline

#####  #####
sudo apt-get install -y nginx git vim zip htop
sudo apt-get install -y build-essential

# 安装 composer
echo "----> start installing composer ..."
sudo curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/bin/composer
sudo rm -f composer.phar 

# 安装 mysql5.6
echo "----> start installing mysql5.6 ..."
sudo apt-get -y install debconf-utils
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password MYSQL_20170324_!@#'  # 设置mysql的root密码！！
sudo debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password MYSQL_20170324_!@#'
sudo apt-get -y install mysql-server-5.6 mysql-client-5.6

##### 处理vim配置文件 #####
if [ -s "$HOME/.vim/bundle/Vundle.vim" ]
then
    #echo "Vundle already set!"
    echo
else
    sudo git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
fi

if [ -s "$HOME/.vimrc" ]
then
    #echo "$file already exists!"
    mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
    rm -f "$HOME/.vimrc"
else
    #echo "$file not found, create link..."
    echo
fi

ln -s "$PWD/.vimrc" "$HOME/"

##### 处理用户配置文件 #####
cat "$PWD/.bashrc_add" >> "$HOME/.bashrc"   # TODO 避免多次执行
source "$HOME/.bashrc"
