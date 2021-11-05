#!/bin/sh
#Bootstrapping script for Debian (Stable or Sid) systems.

set -e 

#---------------------------------
#------ Debstrap Functions: ------
#---------------------------------

initialize() {
	printf "Initializing bootstrap...\n"
	printf " \n"
	printf "Updating system...\n"
	printf " \n"
	sudo apt-get update && \
	sudo apt-get upgrade -y
}

commons() {
	printf "Installing commonly used packages...\n"
	sudo apt-get install -y \
		acpi-support \
		alsa-utils \
		bash-completion \
		calcurse \
		default-jdk \
		deja-dup \
		fd-find \
		firmware-linux-nonfree \
		firmware-misc-nonfree \
		fonts-font-awesome \
		foot \
		fzf \
		git \
		gucharmap \
		htop \
		intel-microcode \
		librecad \
		libreoffice \
		libreoffice-java-common \
		libreoffice-style-sifr \
		lm-sensors \
		lollypop \
		neofetch \
		neovim \
		ocrmypdf \
		pm-utils \
		printer-driver-escpr \
		sqlite3 \
		texlive-full \
		thermald \
		tmux \
		tree \
		toilet \
		vim-gtk \
		vlc 
}

sidtools() {
	printf "Installing Debian Sid related packages...\n"
	sudo apt-get install -y \
		apt-listbugs \
		apt-listchanges \
		apt-utils \
		blender \
		bombadillo \
		build-essential \
		create-resources \
		gimp \
		inkscape \
		needrestart \
		reportbug-gtk \
		scribus \ 
		youtube-dl
}

waytools() {
	printf "Installing Wayland related packages...\n"
	sudo apt-get install -y \
		brightnessctl \
		eog \
		evince \
		gammastep \
		grimshot \
		mako-notifier \
		nautilus \
		pavucontrol \
		sway \
		swaylock \
		swayidle \
		waybar \
		wdisplays \
		wlogout \
		wofi \
		wf-recorder \
		wtype \
		xdg-desktop-portal-gtk \
		xdg-desktop-portal-wlr \
		xdg-user-dirs-gtk \
		xdg-utils \
		xwayland 
}

gnome_setup() {
	printf "Installing Gnome extensions...\n"
	sudo apt-get install -y \
		gnome-shell-extension-system-monitor \
		gnome-shell-extension-dashtodock \
		gnome-shell-extension-appindicator 
	printf "Setting up Gnome...\n"
	dconf load / < ~/Debstrap/full-desktop-backup
}

flathub() {
	printf "Setting up flathub remote...\n"
	printf " \n"
	sudo apt-get install flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

bibliographical() {
	printf "Installing academic related flatpaks\n"
	printf " \n" 
	flatpak install flathub org.zotero.Zotero
	flatpak install flathub com.github.johnfactotum.Foliate
}

flatgraphics() {
	printf "Installing graphic design related flatpaks...\n"
	flatpak install flathub org.gimp.GIMP	
	flatpak install flathub org.inkscape.Inkscape
	flatpak install flathub net.scribus.Scribus
	flatpak install flathub org.kde.krita
}

dots() {
	printf "Capturing dotfiles...\n"
	printf " \n"
	git clone git@github.com:argosatcore/Deb_Dots.git 
	printf " \n" 
	printf "Deploying  dotfiles...\n"
	printf " \n"
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
}

sshkey() {
	printf "Generating ssh key...\n"
	ssh-keygen -t ed25519 
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_ed25519
	printf "Add the SSH key to your github account\n"
	cat ~/.ssh/id_ed25519.pub
	printf "Press any key to continue\n"
	read y
	printf "Testing ssh connection"\n
	ssh -T git@github.com
}

end() {
	printf "Bootstrapping complete. Welcome back, Argos.\n"
}

remember() {
	printf "Remember, those who forget their history are condemned to live it again, poorly.\n"
	printf "Remember...\n"
	printf "...\n"
	nvim ~/Debstrap/project-history.en.txt
}


#-------------------------------
#------ Debstrap Options: ------
#-------------------------------


# 1---- Initialize script:
while true; do
    read -p "Do you want to initialize this script?" yn
    case $yn in
        [Yy]* ) initialize; break;;
        [Nn]* ) printf "Aborting script.\n"; exit;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 2----- Installation of the commons:
while true; do
    read -p "Do you want to install commons?" yn
    case $yn in
        [Yy]* ) commons; break;;
        [Nn]* ) printf "Skipping commons installation.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 3----- Installation of useful programs for Sid:
while true; do
    read -p "Do you want to install sidtools?" yn
    case $yn in
        [Yy]* ) sidtools; break;;
        [Nn]* ) printf "Skipping sidtools installation.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 4----- Installation of useful Wayland programs:
while true; do
    read -p "Do you want to install waytools?" yn
    case $yn in
        [Yy]* ) waytools; break;;
        [Nn]* ) printf "Skipping waytools installation.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 5----- Flathub set up:
while true; do
    read -p "Do you want to set up flathub?" yn
    case $yn in
        [Yy]* ) flathub; break;;
        [Nn]* ) printf "Skipping flathub set up.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 6----- Installation of bibliographical programs:
while true; do
    read -p "Do you want to install bibliographic programs?" yn
    case $yn in
        [Yy]* ) bibliographical; break;;
        [Nn]* ) printf "Skipping bibliographical programs.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 7----- Installation of graphical programs as flatpaks:
while true; do
    read -p "Do you want to install graphics programs as flatpaks?" yn
    case $yn in
        [Yy]* ) flatgraphics; break;;
        [Nn]* ) printf "Skipping flatpak graphics programs.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 8----- Ssh key set up:
while true; do
    read -p "Do you want set up your ssh key?" yn
    case $yn in
        [Yy]* ) sshkey; break;;
        [Nn]* ) printf "Skipping ssh key set up.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 9----- Dot files deployment:
while true; do
    read -p "Do you want to deploy your dotfiles?" yn
    case $yn in
        [Yy]* ) dots; break;;
        [Nn]* ) printf "Skipping dot files deployment.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 10---- Load Gnome configuration:
while true; do
    read -p "Do you want to load Gnome configuration?" yn
    case $yn in
        [Yy]* ) gnome_setup; break;;
        [Nn]* ) printf "Skipping Gnome configuration.\n"; break;;
        * ) printf "Please answer yes or no.\n";;
    esac
done


# 11---- Do you remember?
while true; do
    read -p "Do you remember?" yn
    case $yn in
        [Yy]* ) end; exit;;
        [Nn]* ) remember; exit;;
        * ) printf "Please answer yes or no.\n";;
    esac
done
