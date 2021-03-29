#!/bin/bash -xe

##############################################################################################################
echo This script will creates user and it\'s require sudo privileged
##############################################################################################################

export ORIGINAL_USER=$(whoami)

echo "Hello $(whoami),"
echo "Enter the new user name (Ex. john): "
read -r username
export USERNAME="$username"

echo Add new users
adduser "$USERNAME"
passwd "$USERNAME"
usermod -aG wheel "$USERNAME"
echo "User has been added to wheel group"

cd /home/$USERNAME
su $USERNAME
