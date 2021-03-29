#!/bin/bash -xe

##############################################################################################################
echo This script will invoke installtion
##############################################################################################################

if [[ $(uname -r) == *.amzn2.x86_64 ]]; then

    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/add_user.sh)" &&
        sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_sudo_init.sh)" &&
        curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_user_init.sh | sh &&
        curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/el7_ec2_init.sh | sh
else
    printf "This setup is not supported on this OS"
fi
