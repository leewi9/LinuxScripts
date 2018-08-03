# 安装jdk

# 1、直接官网下载源包进行安装配置

# 2、使用apt-get包管理器

# sudo apt-get install default-jdk

# 3、使用PPA安装
# https://launchpad.net/~webupd8team/+archive/ubuntu/java

sudo add-apt-repository ppa:webupd8team/java

sudo apt-get update

sudo apt-cache search all | grep oracle

#####Important#####
# To set Oracle JDK8 as default, install the "oracle-java8-set-default" package.
# E.g.: sudo apt install oracle-java8-set-default
# On Ubuntu systems, oracle-java8-set-default is most probably installed automatically with this package.
######################
sudo apt-get install oracle-java8-installer

# 查看版本
java -version

# 查看版本
javac -version
