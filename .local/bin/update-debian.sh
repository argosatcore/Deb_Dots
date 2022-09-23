#!/usr/bin/sh
set -e 

if expr "$EUID" : '0' >/dev/null; then
    printf "already root\n"
else
    sudo -k 
    if sudo true; then
        printf "Correct password\n"
    else
        printf "Wrong password\n"
        exit 1
    fi
fi

printf "╔══════════════════════════╗\n"
printf "║ Updating Debian Packages ║\n"
printf "╚══════════════════════════╝\n"
sudo apt update 
sudo apt upgrade
printf " \n"
printf "╔═══════════════════╗\n"
printf "║ Updating Flatpaks ║\n"
printf "╚═══════════════════╝\n"
flatpak update
