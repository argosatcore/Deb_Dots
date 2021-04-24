#!/bin/sh
#Bootstrapping script for "Sidified" Debian systems, Wayland edition.
#REMEMBER: This script must be run from the home directory, otherwise setting up the dotfiles will fail.

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
breeze-gtk-theme \
breeze-icon-theme \
brightnessctl \
default-jdk \
deja-dup \
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
tlp \
tmux \
texlive-full \
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
echo 'Capturing dotfiles...'
echo ' '
git clone https://github.com/argosatcore/Deb_Dots.git 
echo ' ' 
echo 'Deploying  dotfiles...'
echo ' '
cd Deb_Dots
cd Pictures
mv Wallpapers/ Pictures/
cd ..
cd .local
mv bin/ ~/.local/
cd share/
mv fonts/ ~/.local/share/
mv icons/ ~/.local/share/
cd ..
cd ..
cd .config/
mv sway/ ~/.config/
mv mako/ ~/.config/
mv waybar/ ~/.config/
mv wlogout/ ~/.config/
mv foot/ ~/.config/
cd ..
mv README.md ~/
mv .git ~/
sudo mv .vim ~/
mv .tmux.conf ~/
sudo mv .vimrc ~/
sudo mv .bashrc ~/
cd 
rm -rf Deb_Dots/
echo ' '
echo 'Bootstrapping complete. Welcome back, Argos.'
