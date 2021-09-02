#!/bin/sh
#Bootstrapping script for Debian (Stable or Sid) systems - Wayland edition.
set -e 

initialize() {
	printf "Initializing bootstrap...\n"
	printf " \n"
	printf "Updating system...\n"
	printf " \n"
	sudo apt update && \
	sudo apt upgrade -y
	printf " \n"
}

commons() {
	printf "Installing commonly used packages...\n"
	sudo apt install -y \
		acpi-support \
		alsa-utils \
		bash-completion \
		calcurse \
		default-jdk \
		deja-dup \
		fd-find \
		fonts-font-awesome \
		foot \
		fzf \
		git \
		gucharmap \
		htop \
		librecad \
		libreoffice \
		libreoffice-java-common \
		libreoffice-style-sifr \
		lm-sensors \
		lollypop \
		neofetch \
		neovim \
		pm-utils \
		printer-driver-escpr \
		sqlite3 \
		texlive-full \
		tlp \
		tmux \
		tree \
		toilet \
		vim-gtk \
		vlc 
	printf " \n"
}

sidtools() {
	printf "Installing Debian Sid related packages...\n"
	sudo apt install -y
		apt-listbugs \
		apt-listchanges \
		apt-utils \
		blender \
		bombadillo \
		build-essential \
		create-resources \
		firefox \
		gimp \
		inkscape \
		needrestart \
		reportbug-gtk \
		scribus \ 
		youtube-dl
	printf "Removing firefox-esr...\n"
	sudo apt remove firefox-esr
	printf " \n"
}

waytools() {
	printf "Installing Wayland related packages...\n"
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
	printf " \n"
}

flathub() {
	printf "Setting up flathub remote...\n"
	printf " \n"
	sudo apt install flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	printf " \n"
}

academics() {
	printf "Installing academic related flatpaks\n"
	printf " \n" 
	flatpak install flathub org.zotero.Zotero
	flatpak install flathub com.github.johnfactotum.Foliate
	printf " \n"
}

graphics() {
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
	printf " \n"
}

trim() {
	printf "Enabling SSD trimming...\n"
	sudo systemctl enable fstrim.timer
	sudo systemctl start fstrim.timer
	printf " \n"
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
	printf " \n"
}

remember() {
	printf "Remember, those who forget their history are condemned to live it again, poorly.\n"
	printf "Remember...\n"
	printf "...\n"
	nvim ~/Debstrap/project-history.en.txt
}

initialize
commons
#sidtools
waytools
flathub
academics
graphics
dots
trim
sshkey
end
remember
