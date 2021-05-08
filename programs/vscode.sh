#!/bin/bash -xe

# https://code.visualstudio.com/docs/setup/linux
echo 'Installing Visual Studio Code with the key and repository'

if [ -x "$(command -v code)" ]; then
    echo '✔️ code installed'
else
    echo 'Installing Code'

    echo Import the Microsoft GPG key
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/

    echo Enable the Visual Studio Code repository
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    echo Update the packages index and install the dependencies
    sudo apt install -y apt-transport-https
    sudo apt update
    echo install the Visual Studio Code package
    sudo apt install -y code
fi

# https://docs.aws.amazon.com/toolkit-for-vscode/latest/userguide/setup-toolkit.html
# https://marketplace.visualstudio.com/itemdetails?itemName=AmazonWebServices.aws-toolkit-vscode

echo 'Installing VS Code extensions'
sleep 2

code --install-extension AmazonWebServices.aws-toolkit-vscode \
    --install-extension teabyii.ayu \
    --install-extension rogalmic.bash-debug \
    --install-extension CoenraadS.bracket-pair-colorizer-2 \
    --install-extension kddejong.vscode-cfn-lint \
    --install-extension streetsidesoftware.code-spell-checker \
    --install-extension ms-azuretools.vscode-docker \
    --install-extension rubbersheep.gi \
    --install-extension HashiCorp.terraform \
    --install-extension ms-toolsai.jupyter \
    --install-extension yzhang.markdown-all-in-one \
    --install-extension mervin.markdown-formatter \
    --install-extension donjayamanne.githistory \
    --install-extension jebbs.plantuml \
    --install-extension ms-vscode.theme-predawnkit \
    --install-extension ms-python.python \
    --install-extensione vsc-python-indent \
    --install-extension foxundermoon.shell-format \
    --install-extension Remisa.shellman \
    --install-extension redhat.vscode-yaml

echo 'Test Visual Studio Code the installation'
sleep 2

code --version
