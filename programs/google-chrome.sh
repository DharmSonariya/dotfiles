#!/bin/bash -xe

echo 'Installing Google Chrome with the key and repository'

if [ -x "$(command -v google-chrome)" ]; then
    echo '✔️ Google Chrome installed'
else
    echo 'Installing Google Chrome'

    echo Add Key:
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

    echo Set repository:
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

    echo Install package:
    sudo apt-get -y update
    sudo apt-get install -y google-chrome-stable
fi
