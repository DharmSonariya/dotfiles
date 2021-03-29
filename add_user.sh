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

sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_sudo_init.sh)" &&
    curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_user_init.sh | sh &&
    curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_ec2_init.sh | sh
