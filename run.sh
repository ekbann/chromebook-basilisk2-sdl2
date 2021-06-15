#!/bin/bash

RED='\033[0;31m'	# Red Color
NC='\033[0m'		# No Color

read -p $'\e[31m>>> Perform system update and upgrade first? (Reboot required) \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt update && sudo apt upgrade -y
	reboot
fi

echo -e "${RED}>>> No update. Installing additional packages in 5 seconds.${NC}"
sleep 5

apt install firmware-linux wicd-cli wicd-curses -y 
apt install xorg lightdm i3-wm i3status suckless-tools xterm feh -y
apt install firmware-intel-sound alsa-utils pulseaudio -y
apt install zip unzip rar unrar wget curl sudo htop -y
apt install dosfstools ntfs-3g exfat-fuse exfat-utils imagemagick -y
apt install fortune cowsay lolcat toilet figlet tty-clock -y

echo -e "${RED}>>> Configuring the additional packages in 5 seconds.${NC}"
sleep 5

alsactl kill quit
alsactl init
pulseaudio --kill
pulseaudio --start
service wicd start
service networking restart
dpkg-reconfigure tzdata

echo "xterm*faceName: Monospace
xterm*faceSize: 12" | tee -a ~/.Xresources

echo "XKBMODEL=\"abnt2\"
XKBLAYOUT=\"br\"
XKBVARIANT=\"\"
XKBOPTIONS=\"\"" | tee /etc/default/keyboard

echo "HandlePowerKey=ignore" | tee -a /etc/systemd/logind.conf
service systemd-logind restart

echo -e "${RED}>>> Installing development packages in 5 seconds.${NC}"
sleep 5

sudo apt install automake build-essential -y

echo -e "${RED}>>> Downloading SDL2 version 2.0.14 in 5 seconds.${NC}"
sleep 5

# Original HOW-TO used SDL2 version 2.0.7

mkdir -p ~/src/sdl2 &&
wget https://www.libsdl.org/release/SDL2-2.0.14.tar.gz -O - | tar -xz -C ~/src/sdl2

echo -e "${RED}>>> Compiling and installing SDL2 in 5 seconds.${NC}"
sleep 5

# SDL2 version 2.0.10 removed the Mir video driver in favor of Wayland.

cd ~/src/sdl2/SDL2-2.0.14 &&

./configure &&
make -j3

sudo make install

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
sudo make install

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

echo -e "${RED}>>> Done. Starting BasiliskII...${NC}"
sleep 5

BasiliskII
