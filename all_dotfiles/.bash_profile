# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
source $HOME/.nvm/nvm.sh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH=/home/linuxbrew/.linuxbrew/opt/python@3.9/libexec/bin:$PATHexport PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@8/bin:$PATH"
