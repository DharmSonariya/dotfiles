#!/bin/bash -xe

# https://brew.sh/
# https://docs.brew.sh/Homebrew-on-Linux
echo 'Installing Homebrew'

sleep 2
if [ -x "$(command -v brew)" ]; then
    echo "✔️ Homebrew installed"
    sleep 2
else
    echo "Installing homebrew now..."
    sleep 2
    echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

echo 'Test the Homebrew installation'
sleep 2

brew --version

echo "Making sure homebrew is up to date"
sleep 2

brew update --force
brew update && brew upgrade && brew cleanup
brew doctor