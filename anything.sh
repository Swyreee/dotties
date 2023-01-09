#!/bin/bash

# ########### Arch with BSPWM install ###########
# No, this is not Ubuntu!
# No, DO NOT BLINDLY RUN THIS FILE!!!!
#
# Basically this is just my autosetup file when I (re)install Arch (btw)!
# ###############################################

# ONE MORE LAST WORD: THIS SCRIPT IS MEANT FOR **ME**!!!!!!!!!!!!!!!!!

# For debugging sake, but it *should* work as I want
echo "Finding 'dotties' directory... This should not take long"
DOTTIES_DIR=$(find $HOME -type d -name "dotties")
echo "Found and using dotties directory $DOTTIES_DIR"
echo "The script *might* ask you the password below"

# Setup custom pacman stuffs: parallel downloads, c o l o r s
sudo sed -i 's/#Color/Color/g' /etc/pacman.conf
sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

# As usual, pacman -Syu
sudo pacman -Syu --noconfirm

# Install server packages
# I assume that you will run this file after booting Arch for the first time
sudo pacman -S --needed --noconfirm pulseaudio networkmanager
sudo systemctl enable NetworkManager.service

# Install Xorg and friends
sudo pacman -S --needed --noconfirm xorg xorg-apps xorg-server xorg-xinit \
                                    mesa mesa-utils libva-intel-driver mesa-amber \
                                    intel-media-driver vulkan-intel \
                                    xf86-video-nouveau xf86-video-intel

# Setup my beloved nano
sudo pacman -S --needed --noconfirm nano
sudo pacman -S --needed --noconfirm unzip wget
wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh

if [ -z $(grep "set linenumbers" $HOME/.nanorc) ]
then
  echo "set linenumbers" >> $HOME/.nanorc
else
  echo "'set linenumbers' set in $HOME/.nanorc"
fi

if [ -z $(grep "set tabstospaces" $HOME/.nanorc) ]
then
  echo "set tabstospaces" >> $HOME/.nanorc
else
  echo "'set tabstospaces' set in $HOME/.nanorc"
fi

if [ -z $(grep "set tabsize 4" $HOME/.nanorc) ]
then
  echo "set tabsize 4" >> $HOME/.nanorc
else
  echo "'set tabsize 4' set in $HOME/.nanorc"
fi

# Install yay AUR helper
if [ -z $(which yay) ]
then
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  sudo rm -r yay
else
  echo "AUR helper yay already installed"
fi

# Install BSPWM, rofi, picom (fork), sxhkd, polybar, notification center(TM), eww
# Technically, setup the desktop
sudo pacman -S --needed --noconfirm rofi sxhkd feh
yay -S --needed --noconfirm --removemake eww
yay -S --needed --noconfirm --removemake bspwm-git
yay -S --needed --noconfirm --removemake picom-animations-git
yay -S --needed --noconfirm --removemake polybar-git
yay -S --needed --noconfirm --removemake deadd-notification-center-bin notify-send-py

# Install and enable LightDM
sudo pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter
sudo systemctl enable lightdm.service

if [ -z $(which vis) ]
then
  # Install cli-visualizer and override with PyWal colors
  sudo pacman -S --needed --noconfirm ncurses fftw cmake
  git clone https://github.com/dpayne/cli-visualizer.git
  cd cli-visualizer
  ./install.sh
  cd ..
  sudo rm -rf cli-visualizer
else
  echo "cli-visualizer already installed"
fi

# Install stuffs for bars
sudo pacman -S --needed --noconfirm acpi alsa-utils playerctl sysstat xdotool jq bc brightnessctl

# Install stuffs for system tray
sudo pacman -S --needed --noconfirm redshift python-gobject
sudo pacman -S --needed --noconfirm network-manager-applet
sudo pacman -S --needed --noconfirm pavucontrol pasystray
sudo pacman -S --needed --noconfirm flameshot

# Install fonts
# References: https://www.reddit.com/r/archlinux/comments/a2g77x/what_are_your_default_font_packages_you_install/
sudo mkdir -p /usr/share/fonts/ && sudo cp -a $DOTTIES_DIR/fonts/. /usr/share/fonts/

sudo pacman -S  --needed --noconfirm  ttf-dejavu ttf-liberation ttf-font-awesome ttf-liberation ttf-droid ttf-ubuntu-font-family \
                                      noto-fonts noto-fonts-cjk noto-fonts-extra noto-fonts-emoji \
                                      adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts

yay -S  --needed --noconfirm --removemake noto-fonts-tc \
                                          siji-git \
                                          nerd-fonts-complete \
                                          ttf-unifont ttf-gelasio-ib ttf-caladea ttf-material-design-icons ttf-carlito ttf-liberation-sans-narrow ttf-ms-fonts ttf-material-icons-git

# Install Greenclip
yay -S --needed --noconfirm --removemake rofi-greenclip

# Install GTK themes
wget -qO- https://git.io/papirus-icon-theme-install | sh
wget -qO- https://git.io/papirus-folders-install | sh
yay -S --needed --noconfirm --removemake catppuccin-gtk-theme-latte
papirus-folders -C yellow --theme Papirus-Light

# Setup needed packages (for me, you should change) as final run!!!
# - Thunar              - File manager (+plugins,mpv,xfce-polkit)
# - neofetch            - Neofetch
# - btop                - Better htop
# - Viewnior            - Image viewer
# - Geany               - GUI text editor
# - Kitty               - Terminal emulator
# - xclip               - Commandline clipboard stuffs
# - font-manager        - Font manager
# - Peazip              - Archive manager
# - XFCE Power Manager  - Brightness and stuffs
# - Komorebi            - Live wallpaper setter (+extensions)
sudo pacman -S --needed --noconfirm thunar neofetch btop viewnior geany kitty xclip font-manager
sudo pacman -S --needed --noconfirm gvfs tumbler ffmpegthumbnailer poppler-glib libgsf libgepub libopenraw freetype2 thunar-volman thunar-archive-plugin thunar-media-tags-plugin mpv
yay -S --needed --noconfirm --removemake peazip-gtk2-bin komorebi
sudo pacman -S --needed --noconfirm gst-libav gstreamer-vaapi gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly libde265
yay -S --needed --noconfirm --removemake gst-plugin-libde265
yay -S --needed --noconfirm --removemake xfce-polkit
sudo pacman -S --needed --noconfirm xfce4-power-manager

# Setup files
mv $HOME/.config/ $HOME/.config_backup/
mkdir -p $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/bspwm/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/polybar/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/systemd/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/kitty/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/picom/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/vis/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/btop/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/Thunar/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/rofi/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/flameshot/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/gtk-3.0/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/eww/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/komorebi/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.config/deadd/ $HOME/.config/
sudo ln -sf $DOTTIES_DIR/.zshrc $HOME/.zshrc
sudo ln -sf $DOTTIES_DIR/.p10k.zsh $HOME/.p10k.zsh
sudo ln -sf $DOTTIES_DIR/.gtkrc-2.0 $HOME/.gtkrc-2.0

# Setup battery saving "bloatwares"
if ! [ -z $(upower) ];
then
    # You should consume these links for more battery saving
    # https://wiki.archlinux.org/title/Power_management
    # https://wiki.archlinux.org/title/CPU_frequency_scaling

    # Intel HW acceleration
    sudo pacman -S --needed --noconfirm intel-media-driver libva-intel-driver
    sudo sed -i 's/MODULES=()/MODULES=(i915,i965,iHD)/g' /etc/mkinitcpio.conf
    sudo mkinitcpio -P

    # Powertop
    sudo pacman -S --needed --noconfirm powertop
    sudo cp $DOTTIES_DIR/.config/systemd/system/powertop.service /etc/systemd/system/powertop.service
    sudo systemctl enable --now powertop.service

    # Laptop setup
    sudo pacman -S --needed --noconfirm acpid
    sudo systemctl enable --now acpid.service

    sudo pacman -S --needed --noconfirm tlp tlp-rdw
    yay -S --needed --noconfirm --removemake tlpui
    sudo systemctl enable --now tlp.service
    sudo systemctl mask systemd-rfkill.service
    sudo systemctl mask systemd-rfkill.socket

    sudo pacman -S --needed --noconfirm thermald
    sudo systemctl enable --now thermald.service

    yay -S --needed --noconfirm --removemake auto-cpufreq
    sudo systemctl enable --now auto-cpufreq.service
else
    echo "No battery installed, skipping installing power savers"
fi

# Post-install stuffs
systemctl enable --user sxhkd.service
systemctl enable --user greenclip.service
sudo touch $HOME/.config/polybar/.curplayer.log

# Clear PM cache
sudo pacman -Sc
yay -Sc

# What to do after this:
#     1. If you are using a touchpad: https://stackoverflow.com/questions/62990795/cannot-set-tapping-enabled-default-on-archlinux
#     2. If your keyboard has a NumLk: https://wiki.archlinux.org/title/Activating_numlock_on_bootup

# Bye!
echo "Installation finished!!!"
echo "And please, for the love of god, DO **NOT** REMOVE THE $DOTTIES_DIR FOLDER!!!! Why? They are **ALL SYMLINKED**!"
echo "Remember to check $HOME/.config_backup directory"
echo "AND REMEMBER TO REBOOT!!!! DO **NOT** USE 'startx' AFTER THIS!!!"
echo "That is all, have a good day and happy ricing!"
