#!/bin/bash

# This script sets up a Bash environment with custom configurations and aliases.

# Exit on any error
set -e

######################### My Configuration ###################################

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

UNDERLINE="\[\033[4m\]"
DEFAULT="\[\033[0m\]"

COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

# Set the prompt
export PS1="\n$BBlue[\h] $BBlue\t $BBlue\u No.$BBlue\# -> $BBlue\$PWD$Color_Off \[\$(git_color)\]\$(git_branch) $Color_Off \n\$ "

# Some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

alias hg='history | grep '
alias pg='ps -ef | grep '

# Check if configurations are already in ~/.bashrc
if ! grep -q "# Custom Bash configurations" ~/.bashrc; then
    # Append configurations to ~/.bashrc
    {
        echo "# Custom Bash configurations"
        echo "export PS1=\"\n\$BBlue[\h] \$BBlue\t \$BBlue\u No.\$BBlue\# -> \$BBlue\$PWD\$Color_Off \[\$(git_color)\]\$(git_branch) \$Color_Off \n\$ \""
        echo "alias ll='ls -alFh'"
        echo "alias la='ls -A'"
        echo "alias l='ls -CF'"
        echo "alias hg='history | grep '"
        echo "alias pg='ps -ef | grep '"
        echo "export Color_Off=\"\[\033[0m\]\""
        echo "export Red=\"\[\033[0;31m\]\""
        echo "export Green=\"\[\033[0;32m\]\""
        echo "export Yellow=\"\[\033[0;33m\]\""
        echo "export Blue=\"\[\033[0;34m\]\""
        echo "export Purple=\"\[\033[0;35m\]\""
        echo "export Cyan=\"\[\033[0;36m\]\""
        echo "export White=\"\[\033[0;37m\]\""
    } >> ~/.bashrc
    echo "Bash configurations added to ~/.bashrc."
else
    echo "Bash configurations already present in ~/.bashrc."
fi

# Install essential Bash tools
sudo apt-get install -y bash-completion 

echo "Bash environment setup completed. Please restart your terminal or run 'source ~/.bashrc' to apply changes." 