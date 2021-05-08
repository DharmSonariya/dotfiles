#!/bin/bash -xe

# https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-linux

if [ -x "$(command -v session-manager-plugin)" ]; then
    echo '✔️ AWS session-manager-plugin installed'
else
    echo "Install Session Manager Plugin on Linux"

    curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
    sudo dpkg -i session-manager-plugin.deb

    echo "Verify the Session Manager plugin installation"
    session-manager-plugin
fi
