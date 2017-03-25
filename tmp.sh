#
adduser leewi9              # 需要设置密码、个人信息等
usermod -a -G sudo leewi9   # 加入sudo
su leewi9
cd ~

#
mkdir A_TOOLS
mkdir A_ONLINE
mkdir A_LOGS


# 修改hostname
sudo vim /etc/hostname
sudo vim /etc/hosts      # 例如 127.0.1.1       linode2845632-Ubuntu.members.linode.com   linode2845632-Ubuntu


# 设置
ssh-keygen  # 按默认提示回车
touch ~/.ssh/authorized_keys
ls -la
cd .ssh
ls -la
cat id_rsa.pub >> authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
cat id_rsa # 再使用puttygen转换
