#! /bin/sh

#Bootstrapping script for Debian-based systems:

echo 'Updating system...'
sudo apt update && \
sudo apt upgrade
echo ' '
echo 'Installing commonly used packages...'
sudo apt install \
	neovim \
	vim-gtk \
	nnn \
	feh \
	git \
	tmux \
	htop \
	xbacklight \ 
	redshift \
	lm-sensors \
	neofetch \
	vlc \
	picom \
	rofi \
	pavucontrol \
	awesome \
	awesome-extra \
	rxvt-unicode \
	bash-completion \
	blender \
	gimp \
	inkscape \
	librecad \
	fonts-font-awesome \
	gucharmap \
	apt-listbugs \
	apt-listchanges \
	deja-dup \
	default-jdk \
	libreoffice-common \
	lxappearance \
	arc-theme 
echo ' '
echo 'Bootstrapping complete.'


