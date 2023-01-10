# ubuntu 20.04

# https://askubuntu.com/a/1336347

sudo apt install resolvconf
sudo systemctl enable --now resolvconf.service

sudo bash -c 'echo "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head'
sudo bash -c 'echo "nameserver 1.1.1.1" >> /etc/resolvconf/resolv.conf.d/head'

sudo resolvconf -u

dig www.yahoo.com
