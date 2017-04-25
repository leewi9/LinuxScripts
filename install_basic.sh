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
sudo apt-get -y update && sudo apt-get -y upgrade

#####  #####
# 开发环境
sudo apt-get install -y binutils build-essential ant gawk

# 工具
sudo apt-get install -y git vim zip htop wget tree
sudo apt-get install -y supervisor
sudo apt-get install -y debian-goodies  # dpigs -H

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

sudo vim -c "PluginInstall" -c "q" -c "q" > /dev/null 
#/dev/tty  # http://stackoverflow.com/questions/29042648/vim-warning-output-not-to-a-terminal

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
