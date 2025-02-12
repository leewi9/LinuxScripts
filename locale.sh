# locale
sudo apt-get install -y locales-all
sudo locale-gen "en_US.UTF-8"
# echo 'LC_ALL="en_US.UTF-8"' | sudo tee --append /etc/default/locale > /dev/null
# echo 'LANG="en_US.UTF-8"' | sudo tee --append /etc/default/locale > /dev/null
# echo 'LANGUAGE="en_US:en"' | sudo tee --append /etc/default/locale > /dev/null
# 上面3句可以用下面来实现
sudo update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US:en"

# timezone
sudo timedatectl set-timezone Asia/Shanghai