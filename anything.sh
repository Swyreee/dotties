#!/bin/bash

# ########### Arch with BSPWM install ###########
# No, this is not Ubuntu!
# No, DO NOT BLINDLY RUN THIS FILE!!!!
#
# Basically this is just my autosetup file when I (re)install Arch (btw)!
# Just clone this file, make anything.sh an executable, if it was not.

# REMEMBER TO REBOOT!!!! DO **NOT** USE `startx` AFTER THIS!!!

# For debugging sake, but it *should* work
echo "Finding 'dotties' directory..."
DOTTIES_DIR=$(find $HOME -type d -name "dotties")
echo "Found and using dotties directory $DOTTIES_DIR"
echo "The script *should* ask you the password below"

# Setup custom pacman stuffs: parallel downloads, c o l o r s
sudo sed -i 's/#Color                /Color                /g' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

# Install Xorg and friends
sudo pacman -S --needed --noconfirm xorg-apps xorg-server xorg-xinit mesa libva-intel-driver intel-media-driver vulkan-intel

# Setup my beloved nano
sudo pacman -S --needed --noconfirm nano
sudo pacman -S --needed --noconfirm unzip wget
wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh
echo "set linenumbers" >> $HOME/.nanorc
echo "set tabstospaces" >> $HOME/.nanorc
echo "set tabsize 4" >> $HOME/.nanorc

# Install yay AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -r yay

# Install BSPWM, polybar, rofi, picom, sxhkd, feh
# Technically, setup the desktop
sudo pacman -S --needed --noconfirm bspwm polybar rofi picom sxhkd feh

# Install and enable LightDM
sudo pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service

# Install cli-visualizer and override with PyWal colors
sudo pacman -S --needed --noconfirm ncurses fftw cmake
git clone https://github.com/dpayne/cli-visualizer.git
cd cli-visualizer
./install.sh
cd ..
sudo rm -rf cli-visualizer
export vis="$DOTTIES_DIR/viswal.sh"

# Setup needed packages (for me, you should change) as final run!!!
# - Dolphin     - File manager
# - neofetch    - Neofetch
# - bashtop     - Better htop
# - Gwenview    - Image viewer
# - Kate        - My favorite GUI text editor
# - Alacritty   - My favorite terminal
# - Ark         - Archive Manager (+unrar for RAR support)
sudo pacman -S --needed --noconfirm dolphin neofetch bashtop gwenview kate alacritty ark
sudo pacman -S --needed --noconfirm unrar

# Setup dotties by symbolic links
# ATTENTION: IF THIS IS **NOT** YOUR **FIRST TIME** RUNNING THIS, COMMENT THEM
#            OR YOU *MIGHT* GET F**KED UP
sudo rm -rf $HOME/.config/
sudo chmod 777 -R $DOTTIES_DIR/.config/
sudo ln -s $DOTTIES_DIR/.config/ $HOME/

echo "Installation finished!!!"
echo "And please, for the love of god, DO NOT REMOVE THE $DOTTIES_DIR FOLDER!!!!"
echo "They are all symlinked, that is all, have a good day and happy ricing!"
