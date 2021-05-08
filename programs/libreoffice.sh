#!/bin/bash -xe

# https://wiki.ubuntu.com/LibreOffice

if [ -x "$(command -v libreoffice)" ]; then
    echo "✔️ LibreOffice installed"
    sleep 2
else
    echo "Installing LibreOffice now..."
    sleep 2

    sudo apt install python-software-properties
    sudo apt-add-repository ppa:libreoffice/ppa
    sudo apt update

fi
