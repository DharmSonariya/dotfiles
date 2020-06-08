#!/bin/bash -e

##############################################################################################################
# This script installs Linux Packages and it's require sudo privileged
##############################################################################################################
echo "Updating installed packages, enabling EPEL repo and installing yum packages"
sleep 2

yum update -y && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && yum groupinstall -y 'Development Tools' && yum install -y \
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
##############################################################################################################
echo 'Installing Google Chrome with the key and repository'

sleep 2
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y ./google-chrome-stable_current_*.rpm
##############################################################################################################
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux

echo Install Session Manager Plugin on Linux
sleep 5
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
yum install -y session-manager-plugin.rpm
##############################################################################################################