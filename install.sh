#!/bin/bash -e

echo "enable universe and multiverse repositories"
sudo add-apt-repository -y universe
sudo add-apt-repository -y multiverse

##############################################################################################################

echo "Update Ubuntu and get standard repository programs"
sudo apt update && sudo apt full-upgrade -y

##############################################################################################################

echo "install Ubuntu Pakages"
{
    sudo apt install -y \
        build-essential \
        clang \
        safeeyes \
        file \
        fontconfig \
        gcc \
        gnome-sound-recorder \
        gnome-tweak-tool \
        konsole \
        nomacs \
        procps \
        unzip \
        wget
} || {
    echo "One or more package failed to install"
}

##############################################################################################################

echo "Snap Install Packages"
{
    sudo snap install \
        zoom-client \
        vlc
} || {
    echo "One or more package failed to install"
}

##############################################################################################################

echo "list of files to download in $HOME"

file_url="https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.aliases 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.aws_helper 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.bash_profile 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.bash_prompt 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.bashrc 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/.gitignore
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/all_dotfiles/upgrade.sh"

for file in ${file_url}; do
    echo "Downloading $file in home directory."
    curl ${file} -O
done

##############################################################################################################

echo "list of files to download in $HOME/programs"
mkdir -p $HOME/programs
programs="copyq docker google-chrome homebrew homebrew konsole libreoffice master-pdf session-manager-plugin vscode"

program="https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/copyq.sh 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/docker.sh 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/google-chrome.sh 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/homebrew.sh 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/libreoffice.sh 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/master-pdf.sh 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/session-manager-plugin.sh 
https://raw.githubusercontent.com/DharmSonariya/dotfiles/master/programs/vscode.sh"

for app in ${program}; do
    echo "Downloading $app in $HOME/programs directory."
    cd $HOME/programs && {
        curl -O ${app}
        cd -
    }
done

echo "Make the downloaded files executable"
chmod +x programs/*.sh

##############################################################################################################

echo "Run all scripts in programs/"
for f in programs/*.sh; do bash "$f" -H; done

echo "Reload .bashrc"
source ~/.bashrc

##############################################################################################################

echo "Installing adobe-source-code-pro-fonts"
sleep 2

wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.zip
if [ ! -d "~/.fonts" ]; then
    mkdir ~/.fonts || :
fi
unzip 1.050R-it.zip
cp source-code-pro-*-it/OTF/*.otf ~/.fonts/
rm -rf source-code-pro*
rm 1.050R-it.zip

fc-cache -f -v

##############################################################################################################
if [ -x "$(command -v calibre)" ]; then
    echo "✔️ Calibre installed"
    sleep 2
else
    echo "Installing Calibre now..."
    sleep 2
    sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
fi

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

echo 'Install the AWS CDK'
sleep 2
npm install -g aws-cdk

echo 'Verify installation'
cdk --version

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

# https://github.com/victorskl/yawsso

echo 'Installing yawsso - Yet Another AWS SSO - sync up AWS CLI v2 SSO login session to legacy CLI v1 credentials.'
sleep 2
python3 -m pip install yawsso

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

# https://github.com/johnnyopao/awsp

echo 'Installing the installation for AWSP - AWS Profile Switcher'

npm install -g awsp

##############################################################################################################

echo "Appending lines to local host SSH config /.ssh/config"
sudo cat >>~/.ssh/config <<EOL
# SSH over Session Manager

host i-* mi-*

ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
EOL

##############################################################################################################

exit 0
