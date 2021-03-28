#!/bin/bash -xe

##############################################################################################################
echo This script will invoke installtion
##############################################################################################################

if [[ $(uname -r) == *.amzn2.x86_64 ]]; then
    curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_sudo_init.sh | sudo sh &&
        /bin/su -c "cd  /home/$USERNAME/ && sh -c $(curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_user_init.sh)" - "$USERNAME" &&
        curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_ec2_init.sh "$USERNAME"
else
    printf "This setup is not supported on this OS"
fi
