#!/bin/bash -e

##############################################################################################################
# This script installs Linux Packages specific for Amazon Linux 2 AMI with sudo privileged
##############################################################################################################
echo "Installing docker"
sleep 2

yum install -y docker
##############################################################################################################
echo 'Starting the Docker'
sleep 2
systemctl start docker

echo 'Test the installation'
sleep 2
docker --version
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
# https://aws.amazon.com/premiumsupport/knowledge-center/ec2-linux-2-install-gui/

echo 'Installing MATE desktop environment'
sleep 2
amazon-linux-extras install -y mate-desktop1.x
bash -c "echo PREFERRED=/usr/bin/mate-session > /etc/sysconfig/desktop"

echo "/usr/bin/mate-session" >~/.Xclients && chmod +x ~/.Xclients
##############################################################################################################
echo 'Installing TigerVNC'
sleep 2
yum install -y tigervnc-server
vncpasswd
vncserver :1
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@.service
sed -i "s/<USER>/$(whoami)/" /etc/systemd/system/vncserver@.service
systemctl daemon-reload
systemctl enable vncserver@:1
systemctl start vncserver@:1
##############################################################################################################
echo 'done!'

echo "Now time for reboot the system and login to the $(whoami) account"
sleep 2
-S reboot
