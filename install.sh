#!/bin/bash

echo "-----> $HOME"
echo "-----> $PWD"

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
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y
sudo apt-add-repository ppa:nginx/stable -y
sudo apt-get -y update && sudo apt-get -y upgrade

# 安装 php5.6
echo "----> start installing php5.6 ..."
sudo apt-get -y install php5.6 php5.6-cli php5.6-fpm php5.6-mysql php5.6-gd php5.6-curl php5.6-mbstring php5.6-dom php5-xdebug php5.6-zip php5.6-bz2 php5.6-json php5.6-opcache php5.6-readline

#####  #####
sudo apt-get install -y nginx git vim zip htop wget
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
    git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
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

sudo vim -c "PluginInstall" -c "q" -c "q"

##### 处理用户配置文件 #####
cat "$PWD/.bashrc_add" >> "$HOME/.bashrc"   # TODO 避免多次执行
source "$HOME/.bashrc"

#####
sudo apt-get -y upgrade

#
sudo apt-get autoremove -y

# TODO System Restart Required
# sudo reboot


# TODO 验证要安装的是否确实都已经正确安装
