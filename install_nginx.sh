#!/bin/bash

#
sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
sudo apt-add-repository -y ppa:nginx/stable

#
sudo apt-get -y update && sudo apt-get -y upgrade

# 安装 nginx
sudo apt-get install -y nginx