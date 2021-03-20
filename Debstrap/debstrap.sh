#!/bin/sh

#Bootstrapping script for "Sidified" Debian systems:
echo 'Initializing bootstrap'
echo ' '
echo 'Updating system...'
echo ' '
sudo apt update && \
sudo apt upgrade -y
echo ' '
echo 'Installing commonly used packages...'
sudo apt install -y \
	acpi \
	apt-listbugs \
	apt-listchanges \
	arc-theme \
	awesome \
	awesome-extra \
	bash-completion \
	blender \
	compton \
	default-jdk \
	deja-dup \
	feh \
	ffmpeg \
	firefox \
	flameshot \
	fonts-font-awesome \
	fzf \
	gimp \
	git \
	gpick \
	gucharmap \
	htop \
	inkscape \
	kupfer \
	librecad \
	libreoffice-common \
	lm-sensors \
	lollypop \
	lxappearance \
	needrestart \
	neofetch \
	neovim \
	nnn \
	pavucontrol \
	picom \
	redshift \
        reportbug-gtk \
	rofi \
	rxvt-unicode \
	suckless-tools \
	tmux \
	texlive-full \
	unclutter \
	vim-gtk \
	vlc \
	xbacklight \
	xcompmgr
sudo apt remove firefox-esr
echo ' '
echo 'Setting up flatpaks...'
echo ' '
sudo apt install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo ' '
echo 'Installing Zotero...'
echo ' ' 
flatpak install flathub org.zotero.Zotero
echo ' '
echo 'Capturing dotfiles...'
echo ' '
git clone https://github.com/argosatcore/Deb_Dots.git 
echo ' ' 
echo 'Deploying  dotfiles.'
echo ' '
cd Deb_Dots
cd Pictures
mv Wallpapers/ Pictures/
cd ..
rm -rf Pictures/
cd .local
mv bin/ ~/.local/
cd share/
mv fonts/ ~/.local/share/
mv icons/ ~/.local/share/
cd ..
cd ..
rm -rf .local/
cd .config/
sudo mv * ~/.config/
cd ..
rm -rf .config/
mv README.md ~/
mv .git ~/
sudo mv .vim ~/
mv .mouseconfig ~/
mv .tmux.conf ~/
sudo mv .vimrc ~/
mv .Xdefaults ~/
mv .xsessrionrc ~/
mv .speedswapper ~/
sudo mv .gtkrc-2.0 ~/
sudo mv .bashrc ~/
cd 
rm -rf Deb_Dots/
echo ' '
echo 'Bootstrapping complete. Welcome back, Argos.'
