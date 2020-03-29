#
adduser leewi9              # 需要设置密码、个人信息等
usermod -a -G sudo leewi9   # 加入sudo
su leewi9
cd ~

#
mkdir _tool
mkdir _log


# 修改hostname
sudo vim /etc/hostname
sudo vim /etc/hosts      # 例如 127.0.1.1       linode2845632-Ubuntu.members.linode.com   linode2845632-Ubuntu
