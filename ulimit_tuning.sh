# ulimit -a

cp /etc/systemd/system.conf /etc/systemd/system.conf.bak
echo 'DefaultLimitNOFILE=6553600' >> /etc/systemd/system.conf
echo 'DefaultLimitNPROC=6553600'  >> /etc/systemd/system.conf

cp /etc/security/limits.conf /etc/security/limits.conf.bak
echo '* soft nofile 102400' >> /etc/security/limits.conf
echo '* hard nofile 102400' >> /etc/security/limits.conf
echo '* soft nproc 102400' >> /etc/security/limits.conf
echo '* hard nproc 102400' >> /etc/security/limits.conf

# reboot
