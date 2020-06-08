#!/bin/bash -e

##############################################################################################################
# This script creates symlinks from the home directory to any desired init_brew_dir in ${homedir}/init_brew_dir
# And also installs Linux Packages through Homebrew and pip
# And it's require user input to configuration
##############################################################################################################

echo "list of files to download in $HOME"
files="aliases bash_profile bash_prompt bashrc"

file_url="https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.aliases 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.bash_profile 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.bash_prompt 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.bashrc 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.gitignore"

for file in ${file_url}; do
    echo "Downloading $file in home directory."
    curl ${file} -O
done

##############################################################################################################
# https://brew.sh/
# https://docs.brew.sh/Homebrew-on-Linux
echo 'Installing Homebrew'
sleep 2
if [ -x "$(command -v brew)" ]; then
    echo "✔️ Homebrew installed"
    sleep 2
else
    echo "Installing homebrew now..."
    sleep 2
    echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

echo 'Test the installation'
sleep 2

brew --version

echo "Making sure homebrew is up to date"
sleep 2
brew update --force
brew update && brew upgrade && brew cleanup
brew doctor
##############################################################################################################
echo "Installing Brew Formulae - packages"
sleep 2
{
    brew tap aws/tap

    brew install \
        gcc \
        git-extras \
        node \
        python \
        pylint \
        black \
        fontconfig \
        tree \
        curl \
        tldr \
        tmux \
        wget \
        lsof \
        htop \
        lynx \
        jq \
        terraform \
        terragrunt \
        packer \
        docker-compose \
        amazon-ecs-cli \
        aws-cdk \
        aws-cfn-tools \
        aws-sam-cli \
        aws-shell \
        awscli
} || {
    echo "One or more brew formulas failed to install"
}

# Make sure the user is the owner of the homebrew directory

echo "For n to work properly, you need to own homebrew stuff - setting $(whoami) as owner of $(brew --prefix)/*"
sleep 2
sudo -tt chown -R $(whoami) $(brew --prefix)/*

##############################################################################################################
echo 'Configuring Source Code Pro Font'
sleep 2
fc-cache -f -v
##############################################################################################################
# https://docs.docker.com/compose/install/
# https://docs.docker.com/compose/completion/

# echo 'Apply executable permissions to the binary'
# sudo -tt chmod +x /usr/local/bin/docker-compose

echo 'Test the Docker Compose installation'
sleep 2

docker-compose --version
##############################################################################################################
# https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html

echo 'Updating the AWS CDK Language Dependencies'
sleep 2
python3 -m pip install --upgrade aws-cdk.core --user

echo 'Test the installation'
sleep 2
cdk --version
##############################################################################################################
# https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html#serverless-sam-cli-install-linux-sam-cli

echo 'Test the  AWS SAM CLI installation'
sleep 2
sam --version
##############################################################################################################
# https://aws.amazon.com/sdk-for-python/
# https://pypi.org/project/boto3/

echo 'Installing the AWS SDK for Python (Boto3)'
sleep 2
python3 -m pip install boto3 --user
echo 'Configuring git'
sleep 2
read -p 'Enter the email address associated with your GitHub account: ' EMAIL
read -p 'Enter your full name (Ex. John Doe): ' USERNAME
##############################################################################################################

echo 'Adding global .gitignore file'
sleep 2
git config --global core.excludesfile ~/.gitignore

echo 'Download Git Auto-Completion'
sleep 2
/bin/bash -c "$(curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o .git-completion.bash)"

echo "Setting global git config with email $EMAIL and username $USERNAME"
sleep 2
git config --global --replace-all user.email "$EMAIL"
git config --global --replace-all user.name "$USERNAME"

echo 'Check the configuration'
sleep 2
git config --list
##############################################################################################################
echo Connections to AWS CodeCommit Repositories with the AWS CLI Credential Helper
sleep 2
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

echo 'Confirm the configuration'
sleep 2
git config --list
##############################################################################################################
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html

echo 'Configuring the AWS CLI'
echo 'Enter your profile name (Ex. produser): '
sleep 2
read -r PROFILENAME
aws configure --profile $PROFILENAME

echo 'Test the installation'
sleep 2
aws --version
##############################################################################################################
echo 'Test Visual Studio Code the installation'
sleep 2
code --version
##############################################################################################################
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux

echo 'Test the installation for Session Manager Plugin on Linux'
session-manager-plugin
sleep 2
##############################################################################################################
echo 'done!'

echo 'Now time for reboot the system and login to the $(whoami) account'
sleep 2
sudo -tt reboot
