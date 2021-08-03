#!/usr/bin/env bash
set -euo pipefail

if [[ "$EUID" = 0 ]]; then
    echo "(1) already root"
else
    sudo -k 
    if sudo true; then
        echo "(2) correct password"
    else
        echo "(3) wrong password"
        exit 1
    fi
fi

sudo apt-get update -y
sudo apt-get upgrade
flatpak update
