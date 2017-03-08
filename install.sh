#!/bin/bash

file="$HOME/.vimrc"

#echo $HOME
#echo $file

if [ -f "$file" ]
then
    #echo "$file already exists!"
    mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
    rm -f "$HOME/.vimrc"
else
    #echo "$file not found, create link..."
fi


ln -s "$PWD/.vimrc" "$HOME/"
