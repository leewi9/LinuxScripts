#!/bin/bash

#echo $HOME
#echo $PWD

if [ -f "$HOME/.vim/bundle/Vundle.vim" ]
then
git clone "https://github.com/VundleVim/Vundle.vim.git" "$HOME/.vim/bundle/Vundle.vim"
fi

if [ -f "$HOME/.vimrc" ]
then
    #echo "$file already exists!"
    mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
    rm -f "$HOME/.vimrc"
else
    #echo "$file not found, create link..."
fi

ln -s "$PWD/.vimrc" "$HOME/"
