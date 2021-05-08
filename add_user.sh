#!/bin/bash -e

##############################################################################################################
echo This script will creates user and it\'s require sudo privileged
##############################################################################################################

if [[ $(lsb_release -d) == *Ubuntu* ]]; then

    export ORIGINAL_USER=$(whoami)

    echo "Hello $(whoami),"
    echo "Enter the new user name (Ex. john): "
    read -r username
    export USERNAME="$username"

    echo Add new users $USERNAME
    adduser "$USERNAME"

    echo Add new users $USERNAME to sudo group
    usermod -aG sudo "$USERNAME"
    echo "User $USERNAME has been added to sudo group"

    echo Login to user $USERNAME account
    su - $USERNAME

else
    printf "This setup is not supported on this OS"
fi
