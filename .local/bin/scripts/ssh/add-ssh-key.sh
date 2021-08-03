#!/bin/bash
# Tested on Ubuntu 18.04
# This script adds an SSH key to the server for the current user
# Grab SSH key from user
while [[ -z "$sshkey" ]]
do
    read -p "public ssh key >> " sshkey
done
# Create ssh directory
mkdir -p ~/.ssh
# Add key to authorized_keys
echo $sshkey >> ~/.ssh/authorized_keys
# Set proper permissions and ownership for ssh directory
chmod -R go= ~/.ssh
chown -R $USER:$USER ~/.ssh