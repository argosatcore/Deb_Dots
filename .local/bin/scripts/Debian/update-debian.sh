#!/usr/bin/bash
set -e 

Title() {
	printf -v Bar '%*s' $((${#1} + 2)) ' '
	printf '%s\n║ %s ║\n%s\n' "╔${Bar// /═}╗" "$1" "╚${Bar// /═}╝"
}

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

Title 'Updating Debian packgaes:'
sudo apt-get update 
sudo apt-get upgrade
printf " \n"
Title 'Updating flatpaks:'
flatpak update
