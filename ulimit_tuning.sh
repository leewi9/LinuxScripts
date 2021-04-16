# ubuntu 18.04

# ulimit -a

#
copy /etc/systemd/system.conf /etc/systemd/system.conf.bak
echo 'DefaultLimitNOFILE=6553600' >> /etc/systemd/system.conf
echo 'DefaultLimitNPROC=6553600'  >> /etc/systemd/system.conf

#
copy /etc/security/limits.conf /etc/security/limits.conf.bak
echo '* soft nofile 102400' >> /etc/security/limits.conf
echo '* hard nofile 102400' >> /etc/security/limits.conf
echo '* soft nproc 102400' >> /etc/security/limits.conf
echo '* hard nproc 102400' >> /etc/security/limits.conf

# 在 /etc/pam.d/common-session 文件中添加下面内容：
# session required pam_limits.so

# reboot
