#!/bin/bash -e

##############################################################################################################
# This script installs Linux Packages specific for CentOS with sudo privileged
##############################################################################################################
echo "Installing docker"
sleep 2

brew install docker
##############################################################################################################
echo 'Starting the Docker'
sleep 2
systemctl start docker

echo 'Test the installation'
sleep 2
sudo -u $1 docker --version
##############################################################################################################
echo 'Manage Docker as a non-root user'
sleep 2
usermod -aG docker "$(whoami)"
newgrp docker <<EOF
echo This is running as group \$(id -gn)
EOF

echo 'Test the installation'
sleep 2
docker --version
##############################################################################################################
echo 'done!'

echo "Now time for reboot the system and login to the $(whoami) account"
sleep 2
sudo -S reboot
