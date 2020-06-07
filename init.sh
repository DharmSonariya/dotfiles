#!/bin/bash -e

##############################################################################################################
# This script creates symlinks from the home directory to any desired init_brew_dir in ${homedir}/init_brew_dir
# And also installs Linux Packages through yum, Homebrew and pip
# And it's require user input to configuration
##############################################################################################################

echo "list of files to download in $HOME"
files="aliases bash_profile bash_prompt bashrc"

file_url="https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/.aliases 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/.bash_profile 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/.bash_prompt 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/.bashrc"

for file in ${file_url}; do
    echo "Downloading $file in home directory."
    echo curl ${file} -O
    curl ${file} -O
done

##############################################################################################################
echo 'enable EPEL repo'
sleep 2

sudo -tt yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm || error=true
##############################################################################################################
echo "Updating installed packages"
sleep 2

sudo -tt yum update -y
##############################################################################################################
echo "Installing yum packages"
sleep 2

sudo -tt yum groupinstall -y 'Development Tools'

sudo -tt yum install -y \
    git \
    ncurses-devel \
    adobe-source-code-pro-fonts
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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
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
##############################################################################################################
echo 'Installing Visual Studio Code with the key and repository'
sleep 2
if [ -x "$(command -v code)" ]; then
    echo '✔️ code installed'
else
    echo 'Installing Code'
    sudo -tt rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo -tt sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    # sudo -tt yum -y check-update
    sudo -tt yum -y install code
fi

echo 'Test the installation'
sleep 2
code --version
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
    --install-extension Remisa.shellman
--install-extension mauve.terraform
##############################################################################################################
echo 'Installing Google Chrome with the key and repository'

sleep 2
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo -tt yum install -y ./google-chrome-stable_current_*.rpm
##############################################################################################################
echo 'Configuring git'
sleep 2
read -p 'Enter the email address associated with your GitHub account: ' EMAIL
read -p 'Enter your full name (Ex. John Doe): ' USERNAME

echo 'Adding global .gitignore file'
sleep 2
git config --global core.excludesfile ~/.gitignore

echo 'Download Git Auto-Completion'
sleep 2
sudo -tt su -c "$(curl 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' >${homedir}/.git-completion.bash)"

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
# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux

echo Install Session Manager Plugin on Linux
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
sudo -tt yum install -y session-manager-plugin.rpm

echo 'Test the installation'
session-manager-plugin
sleep 2
##############################################################################################################
echo 'done!'

echo 'Now time for reboot the system and login to the new user account'
sleep 2
sudo -tt reboot
