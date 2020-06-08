#!/bin/bash -e

##############################################################################################################
echo This script will creates user and invoke installtion
##############################################################################################################

export ORIGINAL_USER=$(whoami)

echo "Hello $(whoami),"
echo "Enter the new user name (Ex. john): "
read -r username
export USERNAME="$username"

echo Add new users
sudo adduser "$USERNAME"
sudo passwd "$USERNAME"
sudo usermod -aG wheel "$USERNAME"
echo "User has been added to wheel group"

echo Add known SSH authorize key, this is specially require for EC2 instance
sudo cp -r /home/"$ORIGINAL_USER"/.ssh/ /home/"$USERNAME"/ && sudo chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"/.ssh

echo Invoke sudo_init.sh invoke user_init.sh to /home/"$USERNAME"
curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/sudo_init.sh | sudo bash \
&& /bin/su -c "cd  /home/$USERNAME/ && sh -c $(curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/user_init.sh)" - "$USERNAME"

if [[ $(uname -r) == *.amzn2.x86_64 ]]
then
    curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/ec2_init.sh "$USERNAME" | sudo bash
elif [[ $(uname -r) == *.el7.x86_64 ]]
then
    curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/centos_init.sh "$USERNAME" | sudo bash
else
    printf "This setup is not supported on this OS"
fi