# chromebook-basilisk2-sdl2

Minimal Basilisk II installation using Debian netinst non-free firmware version on a Chromebook with X.org.

This script will automatically download and compile all the necessary source code to have a fully functional Basilisk II emulator running with SDL2 and without X Windows for maximum performance. In order to have an extremely light Linux system the Raspberry Pi OS Lite was chosen as the base for this project. As of this writing the following versions were used:

    Debian 10 "Buster" netinst non-free firmware version (firmware-10.9.0-amd64-netinst)
    SDL2 version 2.0.14
    Basilisk II version by kanjitalk755

A 200MB disk image is also included here with pre-installed Mac OS 7.6.1 and Prince of Persia 1 for a quick demonstration of sound and graphics at 640x480 and 256 colors.

To install, boot into your freshly created Raspberry Pi OS Lite and login with the default user "pi" (password "raspberry"). Then run the following commands:

    sudo apt install git
    git clone https://github.com/ekbann/chromebook-basilisk2-sdl2
    cd chromebook-basilisk2-sdl2
    bash run.sh

When the script ends, it will run Basilisk II automatically but you can also manually start with the commands below. Enjoy!

NOTE: Whenever you reboot your Pi, you need to reload the snd-pcm-oss module before running Basilisk II for sound output. snd-pcm-oss is a kernel module from ALSA's OssEmulation which emulates the old OSS audio devices /dev/dsp and /dev/audio.

    sudo modprobe snd-pcm-oss
    BasiliskII
    
You can change the screen resolution by editing the .basilisk_ii_prefs and change the "screen" parameter. For some serious work, you can try the following:

    screen win/1024/768
    displaycolordepth 16

Then go to Mac OS 7.6.1 Control Panel and under Monitors, select "Thousands" of colors.

There is a folder called "keyboard" that has the default raw keycodes used by Basilisk II. Basically it converts the host OS scancodes into the emulated Basilisk II keycodes. This allows the ALT and WINDOWS keys to be assigned the COMMAND and OPTION keys respectively. There are many keycode sets depending on which video driver is being used, e.g. X11, Quartz, Linux framebuffer, Cocoa, or Windows. This is especially needed when using non-QWERTY keyboard layouts.
