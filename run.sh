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

# Set keyboard to Brazilian ABNT2
echo "XKBMODEL=\"abnt2\"
XKBLAYOUT=\"br\"
XKBVARIANT=\"\"
XKBOPTIONS=\"\"" | tee /etc/default/keyboard

# Disable the power button to avoid inadvertant shutdowns
echo "HandlePowerKey=ignore" | tee -a /etc/systemd/logind.conf
service systemd-logind restart

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

echo "rom /root/Quadra800.ROM
disk /root/HD200MB
ramsize 142606336
frameskip 0
modelid 14
cpu 4
fpu true
screen win/640/480
displaycolordepth 8" | tee -a ~/.basilisk_ii_prefs

cd
unzip chromebook-basilisk2-sdl2/HD200MB-POP.zip -d /root

echo -e "${RED}>>> Done. Reboot and then start BasiliskII.${NC}"
sleep 5

#reboot
