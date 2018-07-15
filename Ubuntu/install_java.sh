# 安装jdk

# 1、直接官网下载源包进行安装配置

# 2、使用apt-get包管理器

# sudo apt-get install default-jdk

# 3、使用PPA安装
# https://launchpad.net/~webupd8team/+archive/ubuntu/java

sudo add-apt-repository ppa:webupd8team/java

sudo apt-get update

sudo apt-cache search all | grep oracle

sudo apt-get install oracle-java8-installer

# 查看版本
# java -version
# 查看版本
# javac -version

# 在Oracle Java 8 和 Java 7 间切换
# sudo update-java-alternatives -s java-7-oracle
# sudo update-java-alternatives -s java-8-oracle
