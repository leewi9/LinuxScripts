#!/bin/bash

# This script installs and configures Vim with Vundle plugin manager
# and a customized .vimrc configuration

# Exit on any error
set -e

###########################################
# Functions
###########################################

check_dependencies() {
    if ! command -v git >/dev/null 2>&1; then
        echo "Installing git..."
        sudo apt-get update
        sudo apt-get install -y git
    fi
}

install_vundle() {
    local vundle_path="$HOME/.vim/bundle/Vundle.vim"
    
    if [ ! -d "$vundle_path" ]; then
        echo "Installing Vundle..."
        git clone "https://github.com/VundleVim/Vundle.vim.git" "$vundle_path"
    else
        echo "Vundle already installed"
    fi
}

configure_vimrc() {
    local vimrc="$HOME/.vimrc"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local temp_conf="${vimrc}.tmp"

    echo "Configuring .vimrc..."

    # Create new file if it doesn't exist
    if [ ! -f "$vimrc" ]; then
        touch "$vimrc"
    else
        # Backup existing .vimrc
        cp "$vimrc" "${vimrc}.bak_${timestamp}"
    fi

    # Function to check if a setting exists
    setting_exists() {
        local pattern="$1"
        grep -q "^[[:space:]]*$pattern" "$vimrc"
    }

    # Function to add a setting if it doesn't exist
    add_setting() {
        local setting="$1"
        local comment="$2"
        
        if ! setting_exists "$setting"; then
            if [ -n "$comment" ]; then
                echo "\" $comment" >> "$temp_conf"
            fi
            echo "$setting" >> "$temp_conf"
        fi
    }

    # Copy existing content to temp file
    cp "$vimrc" "$temp_conf"

    # Add basic settings if they don't exist
    {
        # Basic settings section
        if ! setting_exists "\" Basic settings"; then
            echo -e "\n\" Basic settings" >> "$temp_conf"
        fi
        add_setting "set hlsearch" "highlight all search results"
        add_setting "set ignorecase" "do case insensitive search"
        add_setting "set incsearch" "show incremental search results as you type"
        add_setting "set number" "display line number"
        add_setting "set noswapfile" "disable swap file"
        add_setting "set exrc"
        add_setting "set secure"

        # Vundle configuration
        if ! grep -q "call vundle#begin()" "$vimrc"; then
            cat >> "$temp_conf" << 'EOF'

" Vundle configuration
set nocompatible
filetype off

" Set up Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Tagbar'
Plugin 'c.vim'
Plugin 'Syntastic'

call vundle#end()
filetype plugin indent on
EOF
        fi

        # Tagbar configuration if not exists
        if ! grep -q "tagbar_type_ruby" "$vimrc"; then
            cat >> "$temp_conf" << 'EOF'

" Tagbar configuration
nmap <C-t> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_type_ruby = {
    \ 'kinds' : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'd:describes',
        \ 'C:contexts',
        \ 'f:methods',
        \ 'F:singleton methods'
    \ ]
\ }
EOF
        fi

        # Encoding settings
        if ! setting_exists "\" Encoding settings"; then
            echo -e "\n\" Encoding settings" >> "$temp_conf"
        fi
        add_setting "set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1"
        add_setting "set enc=utf8"
        add_setting "set fencs=utf8,gbk,gb2312,gb18030"

        # Editor settings
        if ! setting_exists "\" Editor settings"; then
            echo -e "\n\" Editor settings" >> "$temp_conf"
        fi
        add_setting "syntax on"
        add_setting "set paste"
        add_setting "set tabstop=4"
        add_setting "set shiftwidth=4"
        add_setting "set softtabstop=4"
        add_setting "set expandtab"

        # File type specific settings
        if ! grep -q "autocmd.*BufRead.*\.h,\*\.c" "$vimrc"; then
            cat >> "$temp_conf" << 'EOF'

" File type specific settings
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END
EOF
        fi
    } 

    # Replace original with updated config
    mv "$temp_conf" "$vimrc"
    echo "Vim configuration updated while preserving existing settings"
}

install_plugins() {
    echo "Installing Vim plugins..."
    vim -E -s -c "source ~/.vimrc" -c "PluginInstall" -c "qa"
}

show_help() {
    cat << EOF
Usage: $(basename "$0") [-h|--help]

Install and configure Vim with Vundle plugin manager and custom configuration.

Options:
    -h, --help    Show this help message

The script will:
1. Install required dependencies (git)
2. Install Vundle plugin manager
3. Configure .vimrc with custom settings
4. Install configured plugins

Note: 
- DO NOT run this script as root! Vim configuration should be done as regular user.
- Existing .vimrc will be backed up before modification.
- Some commands may ask for sudo password to install dependencies.
EOF
    exit 0
}

check_user() {
    if [ "$(id -u)" -eq 0 ]; then
        echo "Warning: This script should NOT be run as root!"
        echo "Vim configuration should be done as a regular user."
        echo "Please run without sudo: './vim.sh'"
        exit 1
    fi
}

###########################################
# Main Script
###########################################

main() {
    # Show help if requested
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_help
    fi

    echo "Starting Vim setup..."
    
    check_user
    check_dependencies
    install_vundle
    configure_vimrc
    install_plugins
    
    echo "Vim setup completed successfully!"
    echo "Note: Some plugins might require additional configuration."
}

# Run main function
main "$@" 