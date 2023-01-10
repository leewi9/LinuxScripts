# ubuntu 20.04

# https://askubuntu.com/a/1336347

sudo apt install resolvconf
sudo systemctl enable --now resolvconf.service

sudo echo 'nameserver 8.8.8.8' >> /etc/resolvconf/resolv.conf.d/head
sudo echo 'nameserver 1.1.1.1' >> /etc/resolvconf/resolv.conf.d/head

sudo resolvconf -u
