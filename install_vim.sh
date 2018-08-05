##### 处理vim配置文件 #####
if [ -s "$HOME/.vim/bundle/Vundle.vim" ]
then
    #echo "Vundle already set!"
    echo
else
    git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
fi

if [ -s "$HOME/.vimrc" ]
then
    #echo "$file already exists!"
    mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
    rm -f "$HOME/.vimrc"
else
    #echo "$file not found, create link..."
    echo
fi

ln -s "$PWD/install_vimrc" "$HOME/"

sudo vim -c "PluginInstall" -c "q" -c "q" > /dev/null 
#/dev/tty  # http://stackoverflow.com/questions/29042648/vim-warning-output-not-to-a-terminal
