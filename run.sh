#!/bin/bash

RED='\033[0;31m'	# Red Color
NC='\033[0m'		# No Color

read -p $'\e[31m>>> Perform system update/upgrade with packages installation first? (Reboot required) \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt update && apt upgrade -y
	
	# Wireless connectivity and miscellaneous firmware
	apt install firmware-linux wicd-cli wicd-curses -y

	# Sound
	apt install firmware-intel-sound alsa-utils pulseaudio -y

	# X Windows with i3 window manager
	apt install xorg lightdm i3-wm i3status suckless-tools xterm -y

	# Minimal tools and gadgets
	apt install zip unzip rar unrar wget curl sudo htop -y
	apt install dosfstools ntfs-3g exfat-fuse exfat-utils imagemagick -y
	apt install feh fortune cowsay lolcat toilet figlet tty-clock -y
	
	# Required packages for Google Chrome web browser
	apt install fonts-liberation libnspr4 libnss3 xdg-utils -y
	
	# For SDL2 compilation, development packages
	apt install build-essential xorg-dev libudev-dev libts-dev libgl1-mesa-dev libglu1-mesa-dev -y
	apt install libasound2-dev libpulse-dev libopenal-dev libogg-dev libvorbis-dev libaudiofile-dev -y
	apt install libpng12-dev libfreetype6-dev libusb-dev libdbus-1-dev zlib1g-dev libdirectfb-dev -y
	apt install automake libxkbcommon-dev -y
	
	reboot
fi

echo -e "${RED}>>> Configuring the additional packages in 5 seconds.${NC}"
sleep 5

alsactl kill quit
alsactl init
pulseaudio --kill
pulseaudio --start
service wicd start
service networking restart
dpkg-reconfigure tzdata

# Resize the xterm font to a larger size to be more readable
echo "xterm*faceName: Monospace
xterm*faceSize: 12" | tee -a ~/.Xresources

# Add volume indicator in the i3 status bar
sed -i '/^order += \"tz/a order += \"volume master\"' /etc/i3status.conf
echo "volume master {
    format = \"V: %volume\"
    format_muted = \"V: X\"
    device = \"default\"
    mixer = \"Master\"
    mixer_idx = 0
}" | tee -a /etc/i3status.conf

# Set keyboard to Brazilian ABNT2
# If you have the US model, use: XKBLAYOUT="us" and XKBVARIANT=""
echo "XKBMODEL=\"pc105\"
XKBLAYOUT=\"br\"
XKBVARIANT=\"nodeadkeys\"
XKBOPTIONS=\"\"" | tee /etc/default/keyboard

# Disable the power button to avoid inadvertant shutdowns
echo "HandlePowerKey=ignore" | tee -a /etc/systemd/logind.conf
service systemd-logind restart

# Remap "pc105" keyboard layout SEARCH key with CAPS_LOCK key for X windows
sed -i '/key <LWIN>/c\    key <LWIN> {\t[ Caps_Lock\t\t]\t};' /usr/share/X11/xkb/symbols/pc

# Clear the xkb settings cache
rm -rf /var/lib/xkb/*

echo -e "${RED}>>> Installing the latest version of Google Chrome in 5 seconds.${NC}"
sleep 5

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb

echo -e "${RED}>>> Downloading SDL2 version 2.0.14 in 5 seconds.${NC}"
sleep 5

mkdir -p ~/src/sdl2 &&
wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz -O - | tar -xz -C ~/src/sdl2

echo -e "${RED}>>> Compiling and installing SDL2 in 5 seconds.${NC}"
sleep 5

# SDL2 version 2.0.10 removed the Mir video driver in favor of Wayland.

cd ~/src/sdl2/SDL2-2.0.14 &&

./configure &&
make -j3

make install

# Update the library links/cache
ldconfig

echo -e "${RED}>>> Downloading Basilisk II in 5 seconds.${NC}"
sleep 5

cd ~/src
git clone https://github.com/kanjitalk755/macemu

echo -e "${RED}>>> Compiling and installing Basilisk II in 5 seconds.${NC}"
sleep 5

cd macemu/BasiliskII/src/Unix

NO_CONFIGURE=1 ./autogen.sh &&
./configure --enable-sdl-audio \
            --enable-sdl-video \
            --without-gtk --disable-jit-compiler &&
make -j3

strip BasiliskII
make install

echo -e "${RED}>>> Setting up some Basilisk II preferences.${NC}"

echo "rom Quadra800.ROM
disk HD200MB
ramsize 142606336
frameskip 0
modelid 14
cpu 4
fpu true
screen win/640/480
displaycolordepth 8
keycodes true
keycodefile BasiliskII_keycodes
swap_opt_cmd false" | tee -a ~/.basilisk_ii_prefs

cd ~
unzip chromebook-basilisk2-sdl2/HD200MB-POP.zip -d /root
cp chromebook-basilisk2-sdl2/Quadra800.ROM .
cp chromebook-basilisk2-sdl2/keyboard/BasiliskII_keycodes .

echo -e "${RED}>>> Done. Reboot and then start BasiliskII.${NC}"
echo -e "${RED}>>> (Install the Brazilian ABNT2 keyboard layout if needed)${NC}"
sleep 5

#reboot
