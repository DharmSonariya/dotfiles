#!/bin/bash -xe

#https://copyq.readthedocs.io/en/latest/installation.html

if [ -x "$(command -v copyq)" ]; then
    echo "✔️ CopyQ installed"
    sleep 2
else
    echo "Installing CpoyQ now..."
    sleep 2

    sudo apt install software-properties-common python-software-properties
    sudo add-apt-repository ppa:hluk/copyq
    sudo apt update
    sudo apt install copyq
fi
