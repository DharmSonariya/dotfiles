# dotfiles

My dotfiles and my personal preferences


## Prerequisites

To set the sudo password timeout value, use the passwd_timeout parameter. First open the /etc/sudoers file with super user privileges using sudo and visudo commands like so:

``` 
sudo -i

visudo
```

Then add the following defaults entry, it implies that the sudo password prompt will time out after 60 minutes once sudo is invoked by a user.

``` 
Defaults        env_reset,timestamp_timeout=60
```

## This script will create a user and add user to sudo group

``` 
eval "$(curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/add_user.sh)"
```

## Run the interactive script

``` 
eval "$(curl -fsSL https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/install.sh)"
```
