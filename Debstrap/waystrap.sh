#!/bin/sh
#Bootstrapping script for "Sidified" Debian systems - Wayland edition.
echo 'Initializing bootstrap...'
echo ' '
echo 'Updating system...'
echo ' '
sudo apt update && \
sudo apt upgrade -y
echo ' '
echo 'Installing commonly used packages...'
sudo apt install -y \
	alsa-utils \
	apt-listbugs \
	apt-listchanges \
	apt-utils \
	bash-completion \
	blender \
	brightnessctl \
	bombadillo \
	build-essential \
	default-jdk \
	deja-dup \
	eog \
	evince \
	fd-find \
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
	libreoffice \
	libreoffice-java-common \
	libreoffice-style-sifr \
	lm-sensors \
	lollypop \
	mako-notifier \
	nautilus \
	needrestart \
	neofetch \
	neovim \
	pavucontrol \
	printer-driver-escpr \
	reportbug-gtk \
	scribus \
	sway \
	swaylock \
	swayidle \
	texlive-full \
	tlp \
	tmux \
	tree \
	vim-gtk \
	vlc \
	waybar \
	wdisplays \
	wlogout \
	wofi \
	wf-recorder \
	wtype \
	xdg-utils \
	xdg-desktop-portal-gtk \
	xdg-desktop-portal-wlr \
	xdg-user-dirs-gtk \
	xwayland \
	youtube-dl
echo ' '
echo 'Removing firefox-esr...'
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
echo 'Installing Foliate...'
flatpak install flathub com.github.johnfactotum.Foliate
echo ' '
echo 'Capturing dotfiles...'
echo ' '
git clone git@github.com:argosatcore/Deb_Dots.git 
echo ' ' 
echo 'Deploying  dotfiles...'
echo ' '
mv ~/Deb_Dots/.local/bin/ ~/.local/
mv ~/Deb_Dots/.local/share/fonts/ ~/.local/share/
mv -f ~/Deb_Dots/.config/* ~/.config/
mv ~/Deb_Dots/README.md ~/
mv ~/Deb_Dots/LICENSE ~/
mv ~/Deb_Dots/Debstrap/ ~/
mv ~/Deb_Dots/.git/ ~/
mv ~/Deb_Dots/.inputrc ~/
mv ~/Deb_Dots/.tmux.conf ~/
mv -f ~/Deb_Dots/.vimrc ~/
mv -f ~/Deb_Dots/.bash* ~/
mv -f ~/Deb_Dots/.profile ~/
mv -f ~/Deb_Dots/.vim/ ~/
rm -rf ~/Deb_Dots/
echo ' '
echo 'Enabling trimming of SSD...'
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
echo ' '
echo 'Bootstrapping complete. Welcome back, Argos.'
echo ' ' 
echo 'Remember, those who forget their history are condemned to live it again, poorly.'
echo 'Remember...'
echo '...'
nvim ~/Debstrap/project-history.en.txt
