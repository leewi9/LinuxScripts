##### 处理用户配置文件 #####
cat "$PWD/.bashrc_add" >> "$HOME/.bashrc"   # TODO 避免多次执行
source "$HOME/.bashrc"