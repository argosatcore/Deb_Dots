#! /bin/sh

#Bootstrapping script for Debian-based systems:

echo 'Updating system...'
sudo apt update && \
sudo apt upgrade
echo ' '
echo 'Installing commonly used packages...'
sudo apt install \
	apt-listbugs \
	apt-listchanges \
	arc-theme \
	awesome \
	awesome-extra \
	bash-completion \
	blender \
	default-jdk \
	deja-dup \
	feh \
	ffmpeg \
	fonts-font-awesome \
	fzf \
	gimp \
	git \
	gpick \
	gucharmap \
	htop \
	inkscape \
	librecad \
	libreoffice-common \
	lm-sensors \
	lxappearance \
	neofetch \
	neovim \
	nnn \
	pavucontrol \
	picom \
	redshift \
	rofi \
	rxvt-unicode \
	tmux \
	vim-gtk \
	vlc \
	xbacklight  
echo ' '
echo 'Bootstrapping complete.'


