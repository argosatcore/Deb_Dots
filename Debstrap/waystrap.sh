#!/bin/sh

#Bootstrapping script for "Sidified" Debian systems, Wayland edition:
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
	bash-completion \
	blender \
	brighnessctl \
	default-jdk \
	deja-dup \
	feh \
	firefox \
	fonts-font-awesome \
	foot \
	fzf \
	gammastep \
	gimp \
	git \
	grimshot \
	gucharmap \
	htop \
	inkscape \
	librecad \
	libreoffice-common \
	lm-sensors \
	lollypop \
	lxappearance \
	mako-notifier
	needrestart \
	neofetch \
	neovim \
	nnn \
	pavucontrol \
	reportbug-gtk \
	sway \
	swaylock \
	swayidle \
	tmux \
	texlive-full \
	vim-gtk \
	vlc \
	waybar \
	wdisplays \
	wofi \
	wf-recorder \
	youtube-dl
echo 'Getting rid of Firefox's extended support release package...'
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
