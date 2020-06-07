#!/bin/bash -e

##############################################################################################################
# This script installs Linux Packages and it's require sudo privileged
##############################################################################################################
echo 'enable EPEL repo'
sleep 2

yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm || error=true
##############################################################################################################
echo "Updating installed packages"
sleep 2

yum update -y
##############################################################################################################
echo "Installing yum packages"
sleep 2

yum groupinstall -y 'Development Tools'

yum install -y \
    git \
    ncurses-devel \
    adobe-source-code-pro-fonts
##############################################################################################################
echo 'Installing Visual Studio Code with the key and repository'
sleep 2
if [ -x "$(command -v code)" ]; then
    echo '✔️ code installed'
else
    echo 'Installing Code'
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    # yum -y check-update
    yum -y install code
fi

echo 'Test the installation'
sleep 2
code --version
##############################################################################################################
# https://docs.aws.amazon.com/toolkit-for-vscode/latest/userguide/setup-toolkit.html
# https://marketplace.visualstudio.com/itemdetails?itemName=AmazonWebServices.aws-toolkit-vscode

echo 'Installing VS Code extensions'
sleep 2
code --install-extension AmazonWebServices.aws-toolkit-vscode \
    --install-extension teabyii.ayu \
    --install-extension rogalmic.bash-debug \
    --install-extension CoenraadS.bracket-pair-colorizer-2 \
    --install-extension streetsidesoftware.code-spell-checker \
    --install-extension ms-azuretools.vscode-docker \
    --install-extension rubbersheep.gi \
    --install-extension donjayamanne.githistory \
    --install-extension ms-vscode.theme-predawnkit \
    --install-extension ms-python.python \
    --install-extension Shan.code-settings-sync \
    --install-extensione vsc-python-indent \
    --install-extension foxundermoon.shell-format \
    --install-extension Remisa.shellman
--install-extension mauve.terraform
##############################################################################################################
echo 'Installing Google Chrome with the key and repository'

sleep 2
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y ./google-chrome-stable_current_*.rpm
##############################################################################################################
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux

echo Install Session Manager Plugin on Linux
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
yum install -y session-manager-plugin.rpm
##############################################################################################################