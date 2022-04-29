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

sidshow() {
printf "╔═════════════════════════════════╗\n"
printf "║ Debian Sid Upgradable Packages: ║\n"
printf "╚═════════════════════════════════╝\n"
apt list --upgradeable

}

sidfull() {
printf "╔══════════════════════════╗\n"
printf "║ Full Debian Sid Upgrade: ║\n"
printf "╚══════════════════════════╝\n"
sudo apt full-upgrade 

}

printf "╔═══════════════════════════╗\n"
printf "║ Updating Debian packages: ║\n"
printf "╚═══════════════════════════╝\n"
sudo apt update 

# 0---- Show upgradable packages:
while true; do
    read -p "Do you want to see a list of the upgradable packages?" yn
    case $yn in
        [Yy]* ) sidshow; break;;
        [Nn]* ) printf "Skipping list.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done

# 1---- Perform a full upgrade:
while true; do
    read -p "Do you perform a full upgrade?" yn
    case $yn in
        [Yy]* ) sidfull; break;;
        [Nn]* ) printf "Skipping full upgrade.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done

printf " \n"
printf "╔════════════════════╗\n"
printf "║ Updating Flatpaks: ║\n"
printf "╚════════════════════╝\n"
flatpak update
