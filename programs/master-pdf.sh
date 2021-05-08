#!/bin/bash -xe

# https://code-industry.net/free-pdf-editor/

if [ -x "$(command -v masterpdfeditor5)" ]; then
    echo "✔️ Master PDF installed"
    sleep 2
else
    echo "Installing Master PDF now..."
    sleep 2

    wget https://code-industry.net/public/master-pdf-editor-5.7.60-qt5.x86_64.deb
    sudo apt-get update -y
    sudo dpkg -i master-pdf-editor-5.7.60-qt5.x86_64.deb
    sudo apt-get install -y libsane

fi
