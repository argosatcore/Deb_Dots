#!/usr/bin/sh
set -e 

if expr "$EUID" : '0' >/dev/null; then
    printf "already root\n"
else
    sudo -k 
    if sudo true; then
        printf "correct password\n"
    else
        printf "wrong password\n"
        exit 1
    fi
fi

sudo apt-get update 
sudo apt-get upgrade
flatpak update
