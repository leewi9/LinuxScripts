#!/bin/bash

#echo $HOME
#echo $PWD

if [ -s "$HOME/.vim/bundle/Vundle.vim" ]
then
    #echo "Vundle already set!"
    echo
else
    sudo git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
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

ln -s "$PWD/.vimrc" "$HOME/"
