# 更换内核 Ubuntu 14.04
# 注：Digital Ocean 可以在控制台指定kernel版本。更换后不要reboot，而是poweroff然后从控制台开启机器。
sudo apt-get install linux-image-3.13.0-24-generic  
sudo apt-cache search linux-headers

uname -r
sudo apt-get install linux-image-3.13.0-24-generic  # 安装内核版本

dpkg -l | grep linux-image # 查看系统现有内核版本
sudo apt-get purge linux-image-3.16.0-36-generic  # 卸载现有的内核版本
# You can remove multiple kernels with a command like 
# sudo apt-get purge linux-image-3.13.0-{66,67}-generic 
# (just replace 66,67 with the versions you want to remove)

# 更新引导文件并重启
sudo update-grub 
sudo reboot

# 重启后
sudo apt-get autoremove