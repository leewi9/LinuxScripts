# https://docs.docker.com/install/linux/docker-ce/ubuntu/

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
    
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
sudo apt-get update

sudo apt-get install docker-ce

#
sudo usermod -a -G docker  $USER
# 要logout才会生效

#
echo "DOCKER_OPTS=\"--registry-mirror=https://2h3po24q.mirror.aliyuncs.com\"" | sudo tee -a /etc/default/docker
sudo service docker restart

# 安装 phpmyadmin
# docker run --name myadmin -d -e PMA_ARBITRARY=1 -p 8080:80 phpmyadmin/phpmyadmin


# 安装 docker-compose
sudo apt-get -y install python-pip
sudo pip install docker-compose
