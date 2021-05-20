#!/bin/bash -e

echo "Making sure Ubuntu is up to date"
sleep 2

sudo apt-get autoclean
sudo apt-get clean

sudo apt-get update -y && sudo apt-get upgrade -y

sudo snap refresh

echo "Making sure homebrew is up to date"
sleep 2

brew cleanup && brew update --force && brew upgrade && brew doctor

echo "upgrade python package installer, pip, and virtual environment manager, virtualenv"
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade virtualenv

echo "upgrade AWS CDK Toolkit (which provides the cdk command) version"
npm update -g aws-cdk

echo "Updating the AWS CDK Language Dependencies"
sleep 2

python3 -m pip install --upgrade aws-cdk.core --user
