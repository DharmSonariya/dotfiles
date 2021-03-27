#!/bin/bash -xe
set -x
exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1

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

echo 'Test the Homebrew installation'
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
        npm \
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
        awscli@1
} || {
    echo "One or more brew formulas failed to install"
}

# Make sure the user is the owner of the homebrew directory

echo "For homebrew to work properly, you need to own homebrew stuff - setting $(whoami) as owner of $(brew --prefix)/*"
sleep 2

sudo -S chown -R $(whoami) $(brew --prefix)/*
##############################################################################################################
echo 'Configuring Source Code Pro Font'
sleep 2

fc-cache -f -v
##############################################################################################################
# https://docs.docker.com/compose/install/
# https://docs.docker.com/compose/completion/

# echo 'Apply executable permissions to the binary'
# sudo -S chmod +x /usr/local/bin/docker-compose

echo 'Test the Docker Compose installation'
sleep 2

docker-compose --version
##############################################################################################################
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_CLI_installation.html#ECS_CLI_install
echo 'Test the amazon-ecs-cli installation'
sleep 2

ecs-cli --version
##############################################################################################################
# https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html

echo 'Updating the AWS CDK Language Dependencies'
sleep 2
python3 -m pip install --upgrade aws-cdk.core --user

echo 'Test the AWS CDK installation'
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
##############################################################################################################
echo ==============================================================================================================================
echo 'Configuring git'
echo ==============================================================================================================================
sleep 2

read -p 'Enter the email address associated with your GitHub account: ' EMAIL
read -p 'Enter your full name (Ex. John Doe): ' USERNAME

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
echo ==============================================================================================================================
echo 'Enter your profile name (Ex. produser): '
echo ==============================================================================================================================
sleep 2

read -r PROFILENAME
aws configure --profile $PROFILENAME

echo 'Test the AWS CLI installation'
sleep 2

aws --version
##############################################################################################################
# https://docs.aws.amazon.com/toolkit-for-vscode/latest/userguide/setup-toolkit.html
# https://marketplace.visualstudio.com/itemdetails?itemName=AmazonWebServices.aws-toolkit-vscode

echo 'Installing VS Code extensions'
sleep 2

code --install-extension AmazonWebServices.aws-toolkit-vscode \
    --install-extension teabyii.ayu \
    --install-extension rogalmic.bash-debug \
    --install-extension CoenraadS.bracket-pair-colorizer-2 \
    --install-extension streetsidesoftware.code-spell-checker \
    --install-extension ms-azuretools.vscode-docker \
    --install-extension rubbersheep.gi \
    --install-extension donjayamanne.githistory \
    --install-extension ms-vscode.theme-predawnkit \
    --install-extension ms-python.python \
    --install-extension Shan.code-settings-sync \
    --install-extensione vsc-python-indent \
    --install-extension foxundermoon.shell-format \
    --install-extension Remisa.shellman \
    --install-extension HashiCorp.terraform

echo 'Test Visual Studio Code the installation'
sleep 2

code --version
##############################################################################################################
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux

echo 'Test the Session Manager Plugin on Linux installation'
sleep 2

session-manager-plugin
##############################################################################################################
# https://github.com/johnnyopao/awsp

echo 'Installing the installation for AWSP - AWS Profile Switcher'

npm install -g awsp
##############################################################################################################
