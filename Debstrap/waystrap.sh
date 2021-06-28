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
	apt-listbugs \
	apt-listchanges \
	bash-completion \
	blender \
	brightnessctl \
	default-jdk \
	deja-dup \
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
	libreoffice-common \
	lm-sensors \
	lollypop \
	mako-notifier \
	needrestart \
	neofetch \
	neovim \
	nnn \
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
mv ~/Deb_Dots/Pictures/Wallpapers/ ~/Pictures/
mv ~/Deb_Dots/.local/bin/ ~/.local/
mv ~/Deb_Dots/.local/share/fonts/ ~/.local/share/
mv ~/Deb_Dots/.config/sway/ ~/.config/
mv ~/Deb_Dots/.config/mako/ ~/.config/
mv ~/Deb_Dots/.config/waybar/ ~/.config/
mv ~/Deb_Dots/.config/wlogout/ ~/.config/
mv ~/Deb_Dots/.config/foot/ ~/.config/
mv -f ~/Deb_Dots/.config/gtk-3.0/ ~/.config/
mv ~/Deb_Dots/.config/nvim/ ~/.config/
mv -f ~/Deb_Dots/.config/mimeapps.list ~/.config/
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
echo 'Remember, those who forget their history are condemned to repeat it.'
echo 'Remember...'
echo '...'
nvim ~/Debstrap/project-history.en.txt
