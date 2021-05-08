#!/bin/bash

if [ -x "$(command -v docker)" ]; then
    echo "✔️ Docker installed"
    sleep 2
else
    echo "🐋 Installing Docker now..."
    sleep 2

    sudo apt update
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo docker run hello-world
fi
